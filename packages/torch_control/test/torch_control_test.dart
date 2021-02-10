import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:torch_control/torch_control.dart';

void main() {
  final List<MethodCall> log = <MethodCall>[];
  final controller = TorchController();
  const MethodChannel channel = MethodChannel('torch_control');

  TestWidgetsFlutterBinding.ensureInitialized();

  group('Try to use controller features without initialize', () {
    test('Try to turn on the torch triggers error', () async {
      try {
        await controller.on();
      } catch (error) {
        expect(error, isInstanceOf<AssertionError>());
      }
    });

    test('Try to turn off the torch triggers error', () async {
      try {
        await controller.off();
      } catch (error) {
        expect(error, isInstanceOf<AssertionError>());
      }
    });
  });

  group('Turn on torch test on Android', () {
    setUp(() {
      channel.setMockMethodCallHandler(
          (MethodCall methodCall) async => log.add(methodCall));
      controller.initialize();
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      log.clear();
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
      debugDefaultTargetPlatformOverride = null;
    });

    test('Request check if torch exists should trigger correct call', () async {
      await controller.hasTorch;

      expect(log.first.method, equals('hasTorch'));
    });

    test('When turning on/off, should perform correct calls', () async {
      await controller.on();

      expect(log.first.method, equals('turnOn'));
      expect(log.first.arguments, equals([controller.torchIntensity]));
      expect(controller.isTorchOn, isTrue);

      log.clear();
      await controller.off();

      expect(log.first.method, equals('turnOff'));
      expect(controller.isTorchOn, isFalse);
    });

    test('When turning on with intensity, should dispatch assertion error',
        () async {
      try {
        await controller.on(intensity: 0.4);
      } catch (error) {
        expect(error, isInstanceOf<AssertionError>());
      }
    });
  });

  group('Turn on torch test on ios', () {
    setUp(() {
      channel.setMockMethodCallHandler(
          (MethodCall methodCall) async => log.add(methodCall));
      controller.initialize();
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      log.clear();
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
      debugDefaultTargetPlatformOverride = null;
    });

    test('Request check if torch exists should trigger correct call', () async {
      await controller.hasTorch;

      expect(log.first.method, equals('hasTorch'));
    });

    test('When turning on/off, should perform correct calls', () async {
      await controller.on();

      expect(log.first.method, equals('turnOn'));
      expect(log.first.arguments, equals([controller.torchIntensity]));
      expect(controller.isTorchOn, isTrue);

      log.clear();
      await controller.off();

      expect(log.first.method, equals('turnOff'));
      expect(controller.isTorchOn, isFalse);
    });

    test('When turning on, should perform correct call', () async {
      await controller.on(intensity: 0.4);

      expect(log.first.method, equals('turnOn'));
      expect(log.first.arguments, equals([controller.torchIntensity]));
      expect(controller.torchIntensity, equals(0.4));
      expect(controller.isTorchOn, isTrue);
    });
  });
}
