import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_controller/src/shared_preferences_based_storage.dart';

void main() {
  final storage = SharedPreferencesBasedStorage();

  group('Storage test without initial values', () {
    SharedPreferences.setMockInitialValues({});

    test('Write value to storage and reads it', () async {
      await storage.write<String>(key: 'foo', value: 'bar');

      final foo = await storage.read<String>(key: 'foo');

      expect(foo, equals('bar'));
    });

    test('Write value to storage and deletes it', () async {
      await storage.write<String>(key: 'foo', value: 'bar');
      var foo = await storage.read<String>(key: 'foo');

      expect(foo, equals('bar'));

      await storage.delete('foo');
      foo = await storage.read<String>(key: 'foo');

      expect(foo, isNull);
    });
  });

  group('Storage test with initial values', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({'foo': 'bar', 'integer': 2});
    });

    test('Read values from an initialized storage', () async {
      final foo = await storage.read<String>(key: 'foo');
      final integer = await storage.read<int>(key: 'integer');

      expect(foo, equals('bar'));
      expect(integer, equals(2));
    });

    test('Update values from an initialized storage', () async {
      await storage.write<String>(key: 'foo', value: 'updated');
      final foo = await storage.read<String>(key: 'foo');
      final integer = await storage.read<int>(key: 'integer');

      expect(foo, equals('updated'));
      expect(integer, equals(2));
    });

    test('Wipe values and check if changes', () async {
      await storage.wipe();

      final foo = await storage.read<String>(key: 'foo');
      final integer = await storage.read<int>(key: 'integer');

      expect(foo, isNull);
      expect(integer, isNull);
    });
  });
}
