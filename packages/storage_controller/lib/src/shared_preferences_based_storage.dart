import 'package:storage_controller/src/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'typedefs.dart';

class SharedPreferencesBasedStorage extends Storage {
  final _argumentErrorMsg = '''
    Current type not supported by shared_preferences Api
    
    Please use one of the current: [String, int, bool, double, List<String>].
    
    If you think this is an error, please create an issue at: https://https://github.com/4itworks/opensource_qwkin_dart
  ''';

  final _unimplementedErrorMsg = '''
    Current method is not supported by shared_preferences api
        
    If you think this is an error, please create an issue at: https://https://github.com/4itworks/opensource_qwkin_dart
  ''';
  
  Future<ReaderFunction> _getReadableFunctionBasedOnType(Type type) async {
    final _storage = await SharedPreferences.getInstance();
    
    switch(Type) {
      case String:
        return _storage.getString;
      case int:
        return _storage.getInt;
      case bool:
        return _storage.getBool;
      case double:
        return _storage.getDouble;
      case List:
        return _storage.getStringList;
      default:
        throw ArgumentError(_argumentErrorMsg);
    }
  }

  Future<WriteableFunction> _getWriteableFunctionBasedOnType(Type type) async {
    final _storage = await SharedPreferences.getInstance();

    switch(Type) {
      case String:
        return _storage.setString as WriteableFunction<String>;
      case int:
        return _storage.setInt as WriteableFunction<int>;
      case bool:
        return _storage.setBool as WriteableFunction<bool>;
      case double:
        return _storage.setDouble as WriteableFunction<double>;
      case List:
        return _storage.getStringList as WriteableFunction<List<String>>;
      default:
        throw ArgumentError(_argumentErrorMsg);
    }
  }

  @override
  Future<void> delete(String key) async {
    assert(key != null, "Key named parameter must not be null");

    final _storage = await SharedPreferences.getInstance();
    _storage.remove(key);
  }

  @override
  Future<T> read<T>({String key}) async {
    assert(key != null, "Key named parameter must not be null");

    final storeFnc = await _getReadableFunctionBasedOnType(T);
    return storeFnc(key);
  }

  @override
  Future<Map<String, dynamic>> get values => throw UnimplementedError(_unimplementedErrorMsg);

  @override
  Future<void> wipe() async {
    final _storage = await SharedPreferences.getInstance();
    final _keys = _storage.getKeys();

    _keys.forEach((key) => _storage.remove(key));
  }

  @override
  Future<void> write<T>({String key, T value}) async {
    assert(key != null, "Key named parameter must not be null");

    final storeFnc = await _getWriteableFunctionBasedOnType(T);
    storeFnc(key, value);
  }
}