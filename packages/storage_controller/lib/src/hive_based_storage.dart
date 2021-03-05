import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:storage_controller/src/storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveBasedStorage extends Storage {
  late Box _box;

  static HiveBasedStorage _instance = HiveBasedStorage._internal();
  HiveBasedStorage._internal();
  factory HiveBasedStorage() {
    return _instance;
  }

  Future<void> initialize(
    String storageName, {
    HiveCipher? encryptionCipher,
    bool crashRecovery = true,
    Uint8List? bytes,
  }) async {
    try {
      await Hive.initFlutter();
    } on HiveError catch (_) {
      debugPrint('An instance of hive is already initialized');
    }

    _box = await Hive.openBox(storageName,
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery,
        bytes: bytes);
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
