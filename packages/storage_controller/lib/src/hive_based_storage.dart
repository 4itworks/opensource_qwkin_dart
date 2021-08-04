import 'dart:async';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:storage_controller/src/storage.dart';

class HiveBasedStorage extends Storage {
  late Box _box;

  static HiveBasedStorage _instance = HiveBasedStorage._internal();
  HiveBasedStorage._internal();
  factory HiveBasedStorage() {
    return _instance;
  }

  static Future<void> setup([String? subDir]) async {
    await Hive.initFlutter(subDir);
  }

  Future<void> initialize(
    String storageName, {
    HiveCipher? encryptionCipher,
    bool crashRecovery = true,
    Uint8List? bytes,
  }) async {
    try {
      _box = await Hive.openBox(storageName,
          encryptionCipher: encryptionCipher,
          crashRecovery: crashRecovery,
          bytes: bytes);
    } on HiveError catch (_) {
      print('''
        storage_controller wasn't able to initialize the box, so the storage may fail.
        
        This may be related to the missing call `StorageController.setup([subdir])` on app initialization.
        
        Please certify that you are setting up storage_controller properly.
        
        If you think this is an error, please feel free to open an issue at https://github.com/4itworks/opensource_qwkin_dart
      ''');
    }
  }

  @override
  Future<void> delete(String key) async => await _box.delete(key);

  @override
  Future<T?> read<T>({required String key}) async =>
      (await _box.get(key)) as T?;

  @override
  Future<Map<String, dynamic>> get values async => _box.toMap().cast();

  @override
  Future<void> wipe() async => await _box.clear();

  @override
  Future<void> write<T>({required String key, required T value}) async =>
      await _box.put(key, value);
}
