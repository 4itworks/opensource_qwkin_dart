#!/bin/bash
parameters="$@"
script="git ls-files --modified -- 'pubspec.lock'"

if [[ "$parameters" = *"--deep-check"* ]];
then
  script="git ls-files --modified"
fi

if [[ $(eval "${script}") ]]; then
  echo ""
  echo ""
  echo "These files are not formatted correctly:"
  for f in $(eval "${script}"); do
    echo ""
    echo ""
    echo "-----------------------------------------------------------------"
    echo "$f"
    echo "-----------------------------------------------------------------"
    echo ""
    git --no-pager diff --unified=0 --minimal $f
    echo ""
    echo "-----------------------------------------------------------------"
    echo ""
    echo ""
  done
  if [[ $GITHUB_WORKFLOW ]]; then
    git checkout . > /dev/null 2>&1
  fi
  echo ""
  echo "❌ Some files are incorrectly formatted, see above output."
  echo ""
  echo "To fix these locally, run: 'melos run format'."
  exit 1
else
  echo ""
  echo "✅ All files are formatted correctly."
fi
