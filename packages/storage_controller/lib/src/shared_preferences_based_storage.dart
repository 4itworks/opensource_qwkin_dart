import 'package:storage_controller/src/storage.dart';
import 'package:shared_preferences/shared_preferences.dart'
    if (dart.library.web) 'package:shared_preferences/shared_preferences_web.dart';

class SharedPreferencesBasedStorage extends Storage {
  final _argumentErrorMsg = '''
    Current type not supported by shared_preferences Api
    
    Please use one of the current: [String, int, bool, double].
    
    If you think this is an error, please create an issue at: https://https://github.com/4itworks/opensource_qwkin_dart
  ''';

  final _unimplementedErrorMsg = '''
    Current method is not supported by shared_preferences api
        
    If you think this is an error, please create an issue at: https://https://github.com/4itworks/opensource_qwkin_dart
  ''';

  Future<Function> _getReadableFunctionBasedOnType(Type type) async {
    final _storage = await SharedPreferences.getInstance();

    switch (type) {
      case String:
        return _storage.getString;
      case int:
        return _storage.getInt;
      case bool:
        return _storage.getBool;
      case double:
        return _storage.getDouble;
      default:
        throw ArgumentError(_argumentErrorMsg);
    }
  }

  Future<Function> _getWriteableFunctionBasedOnType<T>(Type type) async {
    final _storage = await SharedPreferences.getInstance();

    switch (type) {
      case String:
        return _storage.setString;
      case int:
        return _storage.setInt;
      case bool:
        return _storage.setBool;
      case double:
        return _storage.setDouble;
      default:
        throw ArgumentError(_argumentErrorMsg);
    }
  }

  @override
  Future<void> delete(String key) async {
    final _storage = await SharedPreferences.getInstance();
    _storage.remove(key);
  }

  @override
  Future<T?> read<T>({required String key}) async {
    final storeFnc = await _getReadableFunctionBasedOnType(T);
    return storeFnc(key);
  }

  @override
  Future<Map<String, dynamic>> get values =>
      throw UnimplementedError(_unimplementedErrorMsg);

  @override
  Future<void> wipe() async {
    final _storage = await SharedPreferences.getInstance();

    _storage.clear();
  }

  @override
  Future<void> write<T>({required String key, required T value}) async {
    final storeFnc = await _getWriteableFunctionBasedOnType(T);
    storeFnc(key, value);
  }
}
