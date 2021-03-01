import 'package:storage_controller/src/storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterSecureStorageBasedStorage extends Storage {
  final _supportedTypes = [String, double, int, bool];
  final _argumentErrorMsg = '''
    Current type not supported by flutter_secure_storage api.
    
    Please use one of the current: [String, int, bool, double].
    
    If you think this is an error, please create an issue at: https://https://github.com/4itworks/opensource_qwkin_dart
  ''';

  IOSOptions _iosOptions;
  AndroidOptions _androidOptions;
  FlutterSecureStorage _flutterSecureStorage;

  static FlutterSecureStorageBasedStorage _instance =
      FlutterSecureStorageBasedStorage._internal();
  FlutterSecureStorageBasedStorage._internal();
  factory FlutterSecureStorageBasedStorage() {
    return _instance;
  }

  void initialize({IOSOptions iosOptions, AndroidOptions androidOptions}) {
    _iosOptions = iosOptions;
    _androidOptions = androidOptions;
    _flutterSecureStorage = FlutterSecureStorage();
  }

  @override
  Future<void> delete(String key) async => await _flutterSecureStorage.delete(
      key: key, iOptions: _iosOptions, aOptions: _androidOptions);

  @override
  Future<T> read<T>({String key}) async {
    assert(_supportedTypes.contains(T), ArgumentError(_argumentErrorMsg));

    final stringValue = await _flutterSecureStorage.read(
        key: key, iOptions: _iosOptions, aOptions: _androidOptions);

    return stringValue as T;
  }

  @override
  Future<Map<String, String>> get values async => await _flutterSecureStorage
      .readAll(iOptions: _iosOptions, aOptions: _androidOptions);

  @override
  Future<void> wipe() async => await _flutterSecureStorage.deleteAll(
      iOptions: _iosOptions, aOptions: _androidOptions);

  @override
  Future<void> write<T>({String key, T value}) async {
    assert(_supportedTypes.contains(T), ArgumentError(_argumentErrorMsg));

    await _flutterSecureStorage.write(
        key: key,
        value: value.toString(),
        iOptions: _iosOptions,
        aOptions: _androidOptions);
  }
}
