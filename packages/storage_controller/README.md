[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

<p align="center">
  <img src="https://raw.githubusercontent.com/4itworks/opensource_qwkin_dart/master/.github/os.png?sanitize=true" width="350px">
</p>

#storage_controller
A flutter `facade` like package to enable fully control and customize your storage needs. 

With this package, you will be able to use the better storage method that fulfill your need for every storage situation in your app.

We support, through a very simple API, these three heavily supported storage libraries:

- [Hive](https://pub.dev/packages/hive)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)

You don't have to support different API's anymore to have access to all these features. Please check us out!

### Installing
- Add `torch_controller: 0.1.2` to your pubspec.yaml

### Configure Android version 
In `[project]/android/app/build.gradle` set `minSdkVersion` to >= 18.
```
android {
    ...
    
    defaultConfig {
        ...
        minSdkVersion 18
        ...
    }

}
```

### Usage

To use this package, some steps are required. Please follow the instructions below:

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

class MySensitiveDataOnFlutterSecureStorage extends StorageController { 
  MySensitiveDataOnFlutterSecureStorage() : super.flutterSecureStorage();
}
```

- Use at your own will! All storages are singletons and persists during the app lifecycle (you can close your app and open again
without loose your data).

*IMPORTANT*: You can just use our read/write api directly, but we suggest you to create your own interface for maintenance
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
the documented api at [Abstract Storage Class](./lib/src/storage.dart);

### Authors
- [Rafael Carvalho Monteiro](https://github.com/rafaelcmm)