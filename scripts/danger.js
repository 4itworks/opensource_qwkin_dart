import { danger, warn, fail } from 'danger';

const getIsTrivial = () => (danger.github.pr.body + danger.github.pr.title).includes('[TRIVIAL]');

const encourageBetterCommits = () => {
  const isTrivial = getIsTrivial();
  const message = 'Some commits messages were badly wrote :( Check some of then!\n';
  const idea = `Please add semantic prefixes to your commit messages!

   Prefixes:
   - feat: You can use when you are adding new functionality or test code on the commit
   - fix: You can add when your commit is fixing some wrong behavior
   - chore: You can use when your commit is adding something miscellaneous (format, bootstrap, excluding imports...)

   Example of commit messages:
   - feat: adding new cool stuff
   - chore: changing a wrong documentation
   - fix: fixing wrong index at stuff

   This is not mandatory, but if you want to learn how to rebase and rewrite wrong commit messages, please check at:
   https://docs.github.com/pt/github/committing-changes-to-your-project/changing-a-commit-message

   Also, try to keep your commit messages short! (less than 100 characters)`;
  let uglyCommits = '';

  danger.git.commits.forEach(commit => {
    if (!commit.message.match(/^(feat:)|(fix:)|(chore:)|(Merge)/g) || commit.message.length > 100) {
      uglyCommits += `${commit.sha} - ${commit.message}<br/>`;
    }
  });

  if (uglyCommits.length > 0 && !isTrivial) {
    warn(`
      ${message}<br/><br/>
      ${uglyCommits}<br/><br/>
      ${idea}
    `);
  }
};

const encourageSmallerPRs = () => {
  const message = 'You are submiting a big pull request! please keep smaller if you can, to make it easier to review!';
  const idea = 'You can ignore it if the task has more than 5 points or the lines are from lock changes.'
  const prThreshold = 600;

  if (danger.github.pr.additions + danger.github.pr.deletions > prThreshold) {
    warn(`${message}<br/><br/><i>${idea}</i>`);
  }
};

const validateLockFile = () => {
  if (danger.github.pr) {
    const pubspecsRegexp = RegExp('packages\\/.*\\/pubspec.yaml');
    const pubspecsLocksRegexp = RegExp('packages\\/.*\\/pubspec.lock');

    const pubspecChanges = danger.git.modified_files.filter(filepath => pubspecsRegexp.test(filepath));
    const lockChanges = danger.git.modified_files.filter(filepath => pubspecsLocksRegexp.test(filepath));

    if (pubspecChanges.length > 0 && !(lockChanges.length > 0)) {
      const message = 'Changes were made to some pubspec.yaml files, but not to pubspec.lock.';
      const idea = 'Perhaps you need to run `melos bootstrap`?';
      fail(`${message}<br/><br/><i>${idea}</i>`);
    }
  }
};

const ensureAssignee = () => {
  if (danger.github.pr && danger.github.pr.assignee === null) {
    fail('Please assign someone to merge this PR. Also, please consider assign reviewers.');
  }
};

const ensureLabels = () => {
  if (danger.github.pr && danger.github.issue.labels === null || danger.github.issue.labels.length === 0) {
    fail('Please assign at least one label to merge this PR.');
  }
};

const validateTests = () => {
  if (danger.github.pr) {
    const idea = "That's OK as long as you're refactoring existing code. Take care to not decrease tests coverages!";
    let message = '';
    const packagesRegExp = RegExp('packages\\/*\\/lib');
    const testsRegExp = RegExp('packages\\/*\\/test');

    const packagesChanges = danger.git.modified_files.filter(filepath => packagesRegExp.test(filepath));
    const testPackagesChanges = danger.git.modified_files.filter(filepath => testsRegExp.test(filepath));

    const hasUntestedChanges = packagesChanges.length > 0 && !(testPackagesChanges.length > 0);

    if (hasUntestedChanges) {
      message += "There are source changes at the packages, but not on its tests!\n\n";
    }

    if (message.length > 0) {
      warn(`${message}<br/><i>${idea}</i>`);
    }
  }
};

if (danger.github) {
  ensureAssignee();
  ensureLabels();
  validateTests();
  validateLockFile();
  encourageSmallerPRs();
  encourageBetterCommits();
} else {
  warn("No danger.github found")
}
