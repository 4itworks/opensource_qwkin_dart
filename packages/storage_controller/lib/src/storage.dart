/// Interface like class [Storage] to define how a storage
/// should work.
///
/// This will be the baseline for all storages defined with each
/// necessary storage method
abstract class Storage {
  /// Getter to access all stored values.
  ///
  /// ```dart
  /// final storage = ExtendedStorage();
  ///
  /// final values = storage.values;
  ///
  /// values -> {};
  /// ```
  Future<Map<String, dynamic>> get values;

  /// Getter to access read value based on a key.
  ///
  /// ```dart
  /// final storage = ExtendedStorage();
  ///
  /// final value = storage.read<String>(key: 'foo');
  ///
  /// value -> '';
  /// ```
  Future<T> read<T>({String key});

  /// Getter to access write value based on a key.
  ///
  /// ```dart
  /// final storage = ExtendedStorage();
  ///
  /// storage.write<String>(key: 'foo', value: 'bar');
  ///
  /// final value = storage.read<String>(key: 'foo');
  ///
  /// value -> 'bar';
  /// ```
  Future<void> write<T>({String key, T value});

  /// Getter to access delete value based on a key.
  ///
  /// ```dart
  /// final storage = ExtendedStorage();
  ///
  /// storage.delete(key: 'foo');
  /// ```
  Future<void> delete(String key);

  /// Getter to access wipe storage data
  ///
  /// ```dart
  /// final storage = ExtendedStorage();
  ///
  /// storage.wipe();
  /// ```
  Future<void> wipe();
}
