import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:storage_controller/src/flutter_secure_storage_based_storage.dart';
import 'package:storage_controller/src/hive_based_storage.dart';
import 'package:storage_controller/src/shared_preferences_based_storage.dart';

import 'package:storage_controller/storage_controller.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MyHiveCustomStorage extends StorageController {
  MyHiveCustomStorage() : super.hive('myHiveCustomStorage');
}

class MySPCustomStorage extends StorageController {
  MySPCustomStorage() : super.sharedPreferences();
}

class MyFSSCustomStorage extends StorageController {
  MyFSSCustomStorage() : super.flutterSecureStorage();
}

void executeCommonActions(StorageController storageController) async {
  await storageController.write<String>(key: 'string', value: 'string');
  await storageController.write<int>(key: 'int', value: 1);
  await storageController.write<double>(key: 'double', value: 1.0);
  await storageController.write<bool>(key: 'bool', value: true);

  var stringValue = await storageController.read<String>(key: 'string');
  var intValue = await storageController.read<int>(key: 'int');
  var doubleValue = await storageController.read<double>(key: 'double');
  var boolValue = await storageController.read<bool>(key: 'bool');

  expect(stringValue, equals('string'));
  expect(intValue, equals(1));
  expect(doubleValue, equals(1.0));
  expect(boolValue, equals(true));

  await storageController.delete('string');
  await storageController.delete('int');
  await storageController.delete('double');
  await storageController.delete('bool');

  stringValue = await storageController.read<String>(key: 'string');
  intValue = await storageController.read<int>(key: 'int');
  doubleValue = await storageController.read<double>(key: 'double');
  boolValue = await storageController.read<bool>(key: 'bool');

  expect(stringValue, isNull);
  expect(intValue, isNull);
  expect(doubleValue, isNull);
  expect(boolValue, isNull);

  await storageController.write<String>(key: 'string', value: 'string');
  await storageController.write<int>(key: 'int', value: 1);
  await storageController.write<double>(key: 'double', value: 1.0);
  await storageController.write<bool>(key: 'bool', value: true);

  // Surrounded with try/catch to avoid unimplemented on shared_preferences
  try {
    var values = await storageController.values;

    expect(values['string'], equals('string'));
    expect(values['int'], equals(1));
    expect(values['double'], equals(1.0));
    expect(values['bool'], equals(true));

    storageController.wipe();

    values = await storageController.values;

    expect(stringValue, isNull);
    expect(intValue, isNull);
    expect(doubleValue, isNull);
    expect(boolValue, isNull);
  } on UnimplementedError catch (e) {
    expect(e, isInstanceOf<UnimplementedError>());
  }
}

void main() {
  group('Hive storage controller tests', () {
    final hiveStorageController = MyHiveCustomStorage();

    hiveStorageController.prepareForTests();

    test('Was hive initialized on controller', () {
      expect(hiveStorageController.method, equals(StorageMethod.HIVE));
      expect(
          hiveStorageController.storageRuntimeType, equals(HiveBasedStorage));
    });

    test('Execute storage operations should work', () {
      executeCommonActions(hiveStorageController);
    });
  });

  group('Shared Preferences storage controller tests', () {
    final sharedPreferencesStorageController = MySPCustomStorage();

    sharedPreferencesStorageController.prepareForTests();

    test('Was hive initialized on controller', () {
      expect(sharedPreferencesStorageController.method,
          equals(StorageMethod.SHARED_PREFERENCES));
      expect(sharedPreferencesStorageController.storageRuntimeType,
          equals(SharedPreferencesBasedStorage));
    });

    test('Execute storage operations should work', () {
      executeCommonActions(sharedPreferencesStorageController);
    });
  });

  group('Flutter secure storage storage controller tests', () {
    final flutterSecureStorageController = MyFSSCustomStorage();
    FlutterSecureStorage flutterSecureStorage;

    setUp(() {
      flutterSecureStorage = MockFlutterSecureStorage();
      flutterSecureStorageController.prepareForTests(
          flutterSecureStorage: flutterSecureStorage);
    });

    test('Was hive initialized on controller', () {
      expect(flutterSecureStorageController.method,
          equals(StorageMethod.FLUTTER_SECURE_STORAGE));
      expect(flutterSecureStorageController.storageRuntimeType,
          equals(FlutterSecureStorageBasedStorage));
    });

    test('Execute storage operations should work', () {
      executeCommonActions(flutterSecureStorageController);
    });
  });
}