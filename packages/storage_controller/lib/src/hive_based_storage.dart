import 'dart:io';
import 'dart:typed_data';

import 'package:storage_controller/src/storage.dart';
import 'package:hive/hive.dart';

class HiveBasedStorage extends Storage {
  final _boxName = 'STORAGE';

  Box _box;

  static HiveBasedStorage _instance = HiveBasedStorage._internal();
  HiveBasedStorage._internal();
  factory HiveBasedStorage() {
    return _instance;
  }

  Future<void> initialize({
    HiveCipher encryptionCipher,
    bool crashRecovery = true,
    String path,
    Uint8List bytes,
  }) async {
    final path = Directory.current.path;

    Hive.init(path);

    _box = await Hive.openBox(_boxName,
        encryptionCipher: encryptionCipher,
        crashRecovery: crashRecovery,
        path: path,
        bytes: bytes);
  }

  @override
  Future<void> delete(String key) async => await _box.delete(key);

  @override
  Future<T> read<T>({String key}) async => (await _box.get(key)) as T;

  @override
  Future<Map<String, dynamic>> get values async => _box.toMap().cast();

  @override
  Future<void> wipe() async => await _box.clear();

  @override
  Future<void> write<T>({String key, T value}) async =>
      await _box.put(key, value);
}
