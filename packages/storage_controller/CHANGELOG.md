## [2.0.1] - 2022-07-06
- feat: Torch usage is not required anymore

## [2.0.0] - 2022-06-24
- chore: Update to use Flutter 3
- chore: Update to use dependencies to the newest versions

**BREAKING CHANGES**
- Migrated to Flutter 3

## [1.2.5] - 2022-01-26
- chore: update libraries in use on storage_controller

## [1.2.4] - 2021-08-04
- fix: removed deprecated methods

## [1.2.3] - 2021-08-04
- chore: added setup to the docs
- chore: bumped required flutter version

## [1.2.2] - 2021-08-04
- fix: fixed hive error on initialize
- feat: created `StorageController.setup()` method to ensure proper setup of any new storages

## [1.2.1] - 2021-07-15
- Feat: Stable null safety
- fix: Fixed broken deps

## [1.1.1-nullsafety.1] - 2021-03-05
- Fixed docs

**BREAKING CHANGES**
- Removed support to FCA

## [1.1.0-nullsafety.2] - 2021-03-05
- Fixed null safety unsecure reports
- Fixed analyze and dart deps

## [1.1.0-nullsafety.1] - 2021-03-04
- chore: Improved docs
- fix: Fixed pubspec.yaml issue
- fix: Fixed tests on nullsafety
- feat: Migrated to null safety

**BREAKING CHANGES**
- Migrated to null safety

## 1.0.3
- fix: `README.md` fixed
- feat: Improved `_ensureInitialized` error message
- feat: Added `Troubleshooting` on `README.md`

## 1.0.1+1
- fix: `README.md` fixed

## 1.0.1
- fix: `README.md` fixed

## 1.0.0
- Small adjustments at based storages
- Improved tests
- Written docs

**BREAKING CHANGES**
- Changed [StorageController] into an abstract class

## 0.1.4
- Implemented [StorageController]
- Implemented [StorageController] and tests

## 0.1.3
- Created [HiveBasedStorage] implementation
- Created [HiveBasedStorage] tests

## 0.1.2
- Created [FlutterSecureStorageBasedStorage] implementation
- Created [FlutterSecureStorageBasedStorage] tests

## 0.1.1
- Created [SharedPreferencesBasedStorage] implementation
- Created [SharedPreferencesBasedStorage] tests
- Updated [Storage] for a better interface API

## 0.1.0
- Created [Storage] interface like class

## 0.0.1
- Released initial files
- Created melos configuration
- Updated `pubspec.yaml`
- Created LICENSE
