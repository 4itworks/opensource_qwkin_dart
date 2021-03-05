import 'package:flutter_test/flutter_test.dart';
import 'package:storage_controller/src/hive_based_storage.dart';
import 'package:storage_controller/src/shared_preferences_based_storage.dart';

import 'package:storage_controller/storage_controller.dart';

class MyHiveCustomStorage extends StorageController {
  MyHiveCustomStorage() : super.hive('myHiveCustomStorage');
}

class MySPCustomStorage extends StorageController {
  MySPCustomStorage() : super.sharedPreferences();
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
    late StorageController hiveStorageController;

    setUp(() async {
      hiveStorageController = MyHiveCustomStorage();
      hiveStorageController.prepareForTests();

      final initialized = await hiveStorageController.isInitialized;

      expect(initialized, isTrue);
    });

    test('Was hive initialized on controller', () async {
      expect(hiveStorageController.method, equals(StorageMethod.HIVE));
      expect(
          hiveStorageController.storageRuntimeType, equals(HiveBasedStorage));
      expect(await hiveStorageController.isInitialized, isTrue);
    });

    test('Execute storage operations should work', () {
      executeCommonActions(hiveStorageController);
    });
  });

  group('Shared Preferences storage controller tests', () {
    late MySPCustomStorage sharedPreferencesStorageController;

    setUp(() async {
      sharedPreferencesStorageController = MySPCustomStorage();
      sharedPreferencesStorageController.prepareForTests();

      final initialized =
          await sharedPreferencesStorageController.isInitialized;

      expect(initialized, isTrue);
    });

    test('Was hive initialized on controller', () async {
      expect(sharedPreferencesStorageController.method,
          equals(StorageMethod.SHARED_PREFERENCES));
      expect(sharedPreferencesStorageController.storageRuntimeType,
          equals(SharedPreferencesBasedStorage));
      expect(await sharedPreferencesStorageController.isInitialized, isTrue);
    });

    test('Execute storage operations should work', () {
      executeCommonActions(sharedPreferencesStorageController);
    });
  });
}
