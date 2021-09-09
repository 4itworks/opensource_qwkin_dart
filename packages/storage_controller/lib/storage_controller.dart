library storage_controller;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_controller/src/hive_based_storage.dart';
import 'package:storage_controller/src/shared_preferences_based_storage.dart';
import 'package:storage_controller/src/storage.dart';

enum StorageMethod { HIVE, FLUTTER_SECURE_STORAGE, SHARED_PREFERENCES }

abstract class StorageController extends Storage {
  final _ensureInitializedMessage = '''
    The [StorageController] subtypes has different initialization methods depending on the storage method
    you are using.
    
    The initialization of the storage types are made when your [StorageController] is instantiated.
    
    To ensure that your storage is ready to use, we provide a future called `StorageController.isInitialized`,
    where you can check if your storage is ready to use.
    
    It will return `true` if the initialization succeeded or `false` if any error occurred.
    
    If you think this is an error, please create an issue at: https://https://github.com/4itworks/opensource_qwkin_dart
  ''';
  final _ensureInitialized = Completer<bool>();

  late StorageMethod _method;
  late Storage _storage;

  StorageMethod get method => _method;

  Future<bool> get isInitialized => _ensureInitialized.future;

  @visibleForTesting
  Type get storageRuntimeType => _storage.runtimeType;

  StorageController.hive(
    String? storageName, {
    HiveCipher? encryptionCipher,
    bool crashRecovery = true,
    Uint8List? bytes,
  }) {
    _method = StorageMethod.HIVE;
    _initializeHive(storageName ?? 'storage',
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery,
        bytes: bytes);
  }

  StorageController.sharedPreferences() {
    _method = StorageMethod.SHARED_PREFERENCES;
    _initializeSharedPreferencesStorage();
  }

  /// Required for usage with Hive library
  static Future<void> setup([String? subDir]) async {
    await HiveBasedStorage.setup(subDir);
  }

  void _initializeHive(
    String storageName, {
    HiveCipher? encryptionCipher,
    bool crashRecovery = true,
    Uint8List? bytes,
  }) async {
    try {
      _storage = HiveBasedStorage();

      await (_storage as HiveBasedStorage).initialize(storageName,
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery,
          bytes: bytes);

      _ensureInitialized.complete(true);
    } catch (e) {
      _ensureInitialized.complete(false);
      rethrow;
    }
  }

  void _initializeSharedPreferencesStorage() {
    try {
      _storage = SharedPreferencesBasedStorage();

      _ensureInitialized.complete(true);
    } catch (e) {
      _ensureInitialized.complete(false);
      rethrow;
    }
  }

  @visibleForTesting
  static void prepareForTests() {
    WidgetsFlutterBinding.ensureInitialized();
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
  }

  @override
  @mustCallSuper
  Future<void> delete(String key) async {
    assert(_ensureInitialized.isCompleted, _ensureInitializedMessage);

    return await _storage.delete(key);
  }

  @override
  @mustCallSuper
  Future<T?> read<T>({required String key}) async {
    assert(_ensureInitialized.isCompleted, _ensureInitializedMessage);

    return await _storage.read<T>(key: key);
  }

  @override
  @mustCallSuper
  Future<Map<String, dynamic>> get values async {
    assert(_ensureInitialized.isCompleted, _ensureInitializedMessage);

    return await _storage.values;
  }

  @override
  @mustCallSuper
  Future<void> wipe() async {
    assert(_ensureInitialized.isCompleted, _ensureInitializedMessage);

    return await _storage.wipe();
  }

  @override
  @mustCallSuper
  Future<void> write<T>({required String key, required T value}) async {
    assert(_ensureInitialized.isCompleted, _ensureInitializedMessage);

    return _storage.write<T>(key: key, value: value);
  }
}
