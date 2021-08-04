[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

<p align="center">
  <img src="https://raw.githubusercontent.com/4itworks/opensource_qwkin_dart/master/.github/os.png?sanitize=true" width="350px">
</p>

# storage_controller
A flutter `facade` like package to enable full control over different storage APIs to fulfill your storage needs.

With this package, you will be able to choose which storage method best fits your needs for every storage situation in your app.

We support, through a very simple API, these three heavily supported storage libraries:

- [Hive](https://pub.dev/packages/hive)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)

You don't have to support different APIs anymore to have access to all these features. Please check us out!

### Installing
- Add `storage_controller` to your pubspec.yaml

### Usage

To use this package, some steps are required. Please follow the instructions below:

- Prepare setup of `StorageController` on your app initialization (required to use hive based storage)
```dart
import 'package:storage_controller/storage_controller.dart';

void main() {
  StorageController.setup();
  runApp(MyApp());
}

/// Rest of Application
```

- Create your own storage extending our exported abstract class `StorageController`
```dart
import 'package:storage_controller/storage_controller.dart';

class MyAwesomeSettingsStorage extends StorageController {}
```
- Call super constructor for the storage method you want to use
```dart
import 'package:storage_controller/storage_controller.dart';

class MyCustomStorageOnHive extends StorageController { 
  MyCustomSettingsOnHive() : super.hive('myCustomSettingsOnHive');
}

class MySettingsOnSharedPreferences extends StorageController { 
  MySettingsOnSharedPreferences() : super.sharedPreferences();
}
```

- Use at your own will! All storages are singletons and persist during the app lifecycle (you can close your app and open it again
without losing your data).

*IMPORTANT*: You can just use our read/write API directly, but we suggest you create your own interface for maintenance
and clarity purposes. Check this suggestion of implementation:

```dart
class SettingsStorage extends StorageController {
  SettingsStorage() : super.sharedPreferences();

  Future<void> saveMyAwesomeConfig(bool config) async => this.write<bool>(key: 'myAwesomeConfig', value: config);
  Future<bool> get myAwesomeConfig async => this.read<bool>(key: 'myAwesomeConfig'); 
  Future<void> clearMyAwesomeConfig() async => this.delete('myAwesomeConfig');
}

void main() async {
  final settingsStorage = SettingsStorage();

  /// Use your abstracted API to give a sematic value to your storage API
  await settingsStorage.saveMyAwesomeConfig(true);
  
  /// That way your project will be easier to maintain and support, 
  final config = await settingsStorage.myAwesomeConfig;

  /// When the devs that work on your project read this block of code, they don't need to know how
  /// it is implemented, just read and know what is being done, and if a bug is fixed inside it, 
  /// it will fix in the entire project
  await settingsStorage.clearMyAwesomeConfig();

  /// At the end of the day, you still can use our exported storage api to perform some specific actions
  /// and achieve other behaviors
  final myStorageData = settingsStorage.values;
  await settingsStorage.write<String>(key: 'someString', 'Foo');
  await settingsStorage.wipe();
}
```

### Abstract `StorageController` explained API

To understand the logic behind every `StorageControlled` method, please check
the documented api at [Abstract Storage Class](https://github.com/4itworks/opensource_qwkin_dart/blob/master/packages/storage_controller/lib/src/storage.dart);

### Troubleshooting
- If you get an `AssertionError` from any of the storage methods telling that the [StorageController]
is not initialized yet, you must ensure that you are executing store operations after [StorageController]
is initialized. For that, we provide a method called `StorageController.isInitialized`. You can check if
is `true` before executing your actions. It will return `false` if any error occurs on the initialization.

- If you have any issues in testing, please try call `StorageController.prepareForTests`.

### Authors
- [Rafael Carvalho Monteiro](https://github.com/rafaelcmm)

### Contributors

<a href="https://github.com/4itworks/opensource_qwkin_dart/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=4itworks/opensource_qwkin_dart" />
</a>

Made with [contributors-img](https://contrib.rocks).
