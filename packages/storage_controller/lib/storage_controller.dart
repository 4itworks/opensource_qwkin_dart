library storage_controller;

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_controller/src/flutter_secure_storage_based_storage.dart';
import 'package:storage_controller/src/hive_based_storage.dart';
import 'package:storage_controller/src/shared_preferences_based_storage.dart';
import 'package:storage_controller/src/storage.dart';

enum StorageMethod { HIVE, FLUTTER_SECURE_STORAGE, SHARED_PREFERENCES }

abstract class StorageController extends Storage {
  final _ensureInitializedMessage = '''
    [StorageController] must be initialized inside `runApp()`.
    
    Please call `StorageController.initialize()` inside your runApp function.
    
    If you think this is an error, please create an issue at: https://https://github.com/4itworks/opensource_qwkin_dart
  ''';
  StorageMethod _method;
  bool _ensureInitialized = false;
  Storage _storage;

  StorageMethod get method => _method;
  bool get isInitialized => _ensureInitialized;

  @visibleForTesting
  Type get storageRuntimeType => _storage.runtimeType;

  StorageController.hive(
    String storageName, {
    HiveCipher encryptionCipher,
    bool crashRecovery = true,
    String path,
    Uint8List bytes,
  }) {
    _method = StorageMethod.HIVE;
    _initializeHive(storageName,
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery,
        path: path,
        bytes: bytes);
  }

  StorageController.flutterSecureStorage(
      {IOSOptions iosOptions, AndroidOptions androidOptions}) {
    _method = StorageMethod.FLUTTER_SECURE_STORAGE;
    _initializeFlutterSecureStorage(
        iosOptions: iosOptions, androidOptions: androidOptions);
  }
  StorageController.sharedPreferences() {
    _method = StorageMethod.SHARED_PREFERENCES;
    _initializeSharedPreferencesStorage();
  }

  void _initializeHive(
    String storageName, {
    HiveCipher encryptionCipher,
    bool crashRecovery = true,
    String path,
    Uint8List bytes,
  }) async {
    _storage = HiveBasedStorage();

    await (_storage as HiveBasedStorage).initialize(storageName,
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery,
        path: path,
        bytes: bytes);

    _ensureInitialized = true;
  }

  void _initializeFlutterSecureStorage(
      {IOSOptions iosOptions, AndroidOptions androidOptions}) {
    _storage = FlutterSecureStorageBasedStorage();

    (_storage as FlutterSecureStorageBasedStorage)
        .initialize(iosOptions: iosOptions, androidOptions: androidOptions);

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
      (_storage as FlutterSecureStorageBasedStorage)
          // ignore: invalid_use_of_visible_for_testing_member
          .setUpMockAndInitialize(flutterSecureStorage);
    }
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
  }

  @override
  @mustCallSuper
  Future<void> delete(String key) async {
    assert(_ensureInitialized, _ensureInitializedMessage);

    return await _storage.delete(key);
  }

  @override
  @mustCallSuper
  Future<T> read<T>({String key}) async {
    assert(_ensureInitialized, _ensureInitializedMessage);

    return await _storage.read<T>(key: key);
  }

  @override
  @mustCallSuper
  Future<Map<String, dynamic>> get values async {
    assert(_ensureInitialized, _ensureInitializedMessage);

    return await _storage.values;
  }

  @override
  @mustCallSuper
  Future<void> wipe() async {
    assert(_ensureInitialized, _ensureInitializedMessage);

    return await _storage.wipe();
  }

  @override
  @mustCallSuper
  Future<void> write<T>({String key, T value}) async {
    assert(_ensureInitialized, _ensureInitializedMessage);

    return _storage.write<T>(key: key, value: value);
  }
}