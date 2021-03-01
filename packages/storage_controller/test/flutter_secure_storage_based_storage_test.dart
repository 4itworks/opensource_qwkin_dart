import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:storage_controller/src/flutter_secure_storage_based_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void testCases(FlutterSecureStorageBasedStorage storage,
    FlutterSecureStorage flutterSecureStorage) {
  test('Should write and read with success', () async {
    await storage.write<int>(key: 'integer', value: 2);
    await storage.write<String>(key: 'string', value: 'String');
    await storage.write<double>(key: 'double', value: 1.5);
    await storage.write<bool>(key: 'bool', value: true);

    verify(flutterSecureStorage.write(
            key: anyNamed('key'),
            value: anyNamed('value'),
            iOptions: anyNamed('iOptions'),
            aOptions: anyNamed('aOptions')))
        .called(4);

    final integer = await storage.read<int>(key: 'integer');
    final string = await storage.read<String>(key: 'string');
    final doubleValue = await storage.read<double>(key: 'double');
    final boolValue = await storage.read<bool>(key: 'bool');

    verify(flutterSecureStorage.read(
            key: anyNamed('key'),
            iOptions: anyNamed('iOptions'),
            aOptions: anyNamed('aOptions')))
        .called(4);

    expect(integer, equals(2));
    expect(string, equals('String'));
    expect(doubleValue, equals(1.5));
    expect(boolValue, equals(true));
  });

  test('Should delete key with success', () async {
    await storage.delete('integer');

    verify(flutterSecureStorage.delete(
            key: anyNamed('key'),
            iOptions: anyNamed('iOptions'),
            aOptions: anyNamed('aOptions')))
        .called(1);
  });

  test('Should delete all with success', () async {
    await storage.wipe();

    verify(flutterSecureStorage.deleteAll(
            iOptions: anyNamed('iOptions'), aOptions: anyNamed('aOptions')))
        .called(1);
  });

  test('Should read all with success', () async {
    await storage.values;

    verify(flutterSecureStorage.readAll(
            iOptions: anyNamed('iOptions'), aOptions: anyNamed('aOptions')))
        .called(1);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = FlutterSecureStorageBasedStorage();
  final flutterSecureStorage = MockFlutterSecureStorage();

  group('FlutterSecureStorageBasedStorage tests with no options', () {
    setUp(() {
      storage.setUpMockAndInitialize(flutterSecureStorage);
      when(flutterSecureStorage.write(
              key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((realInvocation) => null);
      when(flutterSecureStorage.read(key: 'integer'))
          .thenAnswer((realInvocation) async => 2.toString());
      when(flutterSecureStorage.read(key: 'string'))
          .thenAnswer((realInvocation) async => 'String');
      when(flutterSecureStorage.read(key: 'double'))
          .thenAnswer((realInvocation) async => 1.5.toString());
      when(flutterSecureStorage.read(key: 'bool'))
          .thenAnswer((realInvocation) async => true.toString());
    });

    testCases(storage, flutterSecureStorage);
  });

  group('FlutterSecureStorageBasedStorage tests with no options', () {
    final androidOptions = AndroidOptions();
    final iosOptions = IOSOptions();

    setUp(() {
      storage.setUpMockAndInitialize(flutterSecureStorage,
          iosOptions: iosOptions, androidOptions: androidOptions);
      when(flutterSecureStorage.write(
              key: anyNamed('key'),
              value: anyNamed('value'),
              iOptions: iosOptions,
              aOptions: androidOptions))
          .thenAnswer((realInvocation) => null);
      when(flutterSecureStorage.read(
              key: 'integer', iOptions: iosOptions, aOptions: androidOptions))
          .thenAnswer((realInvocation) async => 2.toString());
      when(flutterSecureStorage.read(
              key: 'string', iOptions: iosOptions, aOptions: androidOptions))
          .thenAnswer((realInvocation) async => 'String');
      when(flutterSecureStorage.read(
              key: 'double', iOptions: iosOptions, aOptions: androidOptions))
          .thenAnswer((realInvocation) async => 1.5.toString());
      when(flutterSecureStorage.read(
              key: 'bool', iOptions: iosOptions, aOptions: androidOptions))
          .thenAnswer((realInvocation) async => true.toString());
    });

    testCases(storage, flutterSecureStorage);
  });
}
