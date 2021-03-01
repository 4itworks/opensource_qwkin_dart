library storage_controller;

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_controller/src/flutter_secure_storage_based_storage.dart';
import 'package:storage_controller/src/hive_based_storage.dart';
import 'package:storage_controller/src/shared_preferences_based_storage.dart';
import 'package:storage_controller/src/storage.dart';

enum StorageMethod { HIVE, FLUTTER_SECURE_STORAGE, SHARED_PREFERENCES }

class StorageController extends Storage {
  final _ensureInitializedMessage = '''
    [StorageController] must be initialized inside `runApp()`.
    
    Please call `StorageController.initialize()` inside your runApp function.
    
    If you think this is an error, please create an issue at: https://https://github.com/4itworks/opensource_qwkin_dart
  ''';
  final StorageMethod method;

  bool _ensureInitialized = false;
  Storage _storage;

  @visibleForTesting
  Type get storageRuntimeType => _storage.runtimeType;

  StorageController._(
    this.method, {

    /// flutter_secure_storage optional parameters
    IOSOptions iosOptions,
    AndroidOptions androidOptions,

    /// hive optional parameters
    HiveCipher encryptionCipher,
    bool crashRecovery = true,
    String path,
    Uint8List bytes,
  }) {
    switch (method) {
      case StorageMethod.HIVE:
        _initializeHive();
        break;
      case StorageMethod.FLUTTER_SECURE_STORAGE:
        _initializeFlutterSecureStorage();
        break;
      case StorageMethod.SHARED_PREFERENCES:
        _initializeSharedPreferencesStorage();
        break;
    }
  }

  factory StorageController.hive({
    HiveCipher encryptionCipher,
    bool crashRecovery = true,
    String path,
    Uint8List bytes,
  }) =>
      StorageController._(StorageMethod.HIVE,
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery,
          path: path,
          bytes: bytes);
  factory StorageController.flutterSecureStorage(
          {IOSOptions iosOptions, AndroidOptions androidOptions}) =>
      StorageController._(StorageMethod.FLUTTER_SECURE_STORAGE,
          iosOptions: iosOptions, androidOptions: androidOptions);
  factory StorageController.sharedPreferences() =>
      StorageController._(StorageMethod.SHARED_PREFERENCES);

  void _initializeHive() async {
    _storage = HiveBasedStorage();

    await (_storage as HiveBasedStorage).initialize();

    _ensureInitialized = true;
  }

  void _initializeFlutterSecureStorage() {
    _storage = FlutterSecureStorageBasedStorage();

    (_storage as FlutterSecureStorageBasedStorage).initialize();

    _ensureInitialized = true;
  }

  void _initializeSharedPreferencesStorage() {
    _storage = SharedPreferencesBasedStorage();

    _ensureInitialized = true;
  }

  @visibleForTesting
  void prepareForTests({FlutterSecureStorage flutterSecureStorage}) {
    WidgetsFlutterBinding.ensureInitialized();

    if (_storage is FlutterSecureStorageBasedStorage) {
      // ignore: invalid_use_of_visible_for_testing_member
      (_storage as FlutterSecureStorageBasedStorage)
          .setUpMockAndInitialize(flutterSecureStorage);
    }
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
  }

  @override
  Future<void> delete(String key) async {
    assert(_ensureInitialized, _ensureInitializedMessage);

    return await _storage.delete(key);
  }

  @override
  Future<T> read<T>({String key}) async {
    assert(_ensureInitialized, _ensureInitializedMessage);

    return await _storage.read<T>(key: key);
  }

  @override
  // TODO: implement values
  Future<Map<String, dynamic>> get values async {
    assert(_ensureInitialized, _ensureInitializedMessage);

    return await _storage.values;
  }

  @override
  Future<void> wipe() async {
    assert(_ensureInitialized, _ensureInitializedMessage);

    return await _storage.wipe();
  }

  @override
  Future<void> write<T>({String key, T value}) async {
    assert(_ensureInitialized, _ensureInitializedMessage);

    return _storage.write<T>(key: key, value: value);
  }
}
