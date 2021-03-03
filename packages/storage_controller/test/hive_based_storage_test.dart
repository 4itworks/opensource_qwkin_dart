import 'package:flutter_test/flutter_test.dart';
import 'package:storage_controller/src/hive_based_storage.dart';

void main() {
  final storage = HiveBasedStorage();

  group('Hive storage tests', () {
    setUp(() async {
      await storage.initialize('myAwesomeStorage');
    });

    test('Should write and read with success', () async {
      await storage.write<String>(key: 'foo', value: 'bar');

      final foo = await storage.read<String>(key: 'foo');

      expect(foo, equals('bar'));
    });

    test('Should delete with success', () async {
      await storage.write<String>(key: 'foo', value: 'bar');
      var foo = await storage.read<String>(key: 'foo');

      expect(foo, equals('bar'));

      await storage.delete('foo');
      foo = await storage.read<String>(key: 'foo');

      expect(foo, isNull);
    });

    test('Should wipe with success', () async {
      await storage.write<String>(key: 'foo', value: 'bar');
      var foo = await storage.read<String>(key: 'foo');

      expect(foo, equals('bar'));

      await storage.wipe();
      foo = await storage.read<String>(key: 'foo');

      expect(foo, isNull);
    });

    test('Should get all values with success', () async {
      await storage.write<String>(key: 'foo', value: 'bar');
      await storage.write<int>(key: 'integer', value: 1);

      final values = await storage.values;

      expect(values['foo'], 'bar');
      expect(values['integer'], 1);
    });
  });
}
