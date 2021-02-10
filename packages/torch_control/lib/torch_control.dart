import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TorchControl {
  final _channel = const MethodChannel('torch_control');

  bool _ensureInitialized = false;
  double _torchIntensity;
  bool _debug;
  bool _isTorchOn;
  bool _suppressTorchErrors;

  double get torchIntensity => _torchIntensity;
  bool get isTorchOn => _isTorchOn;

  static final TorchControl _singleton = TorchControl._internal();
  factory TorchControl() {
    return _singleton;
  }
  TorchControl._internal();

  void initialize(
      {double intensity = 1.0,
        bool torchEnabledWhenInitialize = false,
        bool debug = false,
        bool suppressTorchErrors = false}) async {
    _ensureInitialized = true;
    _torchIntensity = intensity;
    _suppressTorchErrors = suppressTorchErrors;

    if (torchEnabledWhenInitialize) {
      _isTorchOn = true;
      on(intensity: _torchIntensity);
    } else {
      _isTorchOn = false;
      off();
    }
  }

  Future<bool> get hasTorch async => await _channel.invokeMethod('hasTorch');

  Future<void> on({double intensity}) async {
    assert(Platform.isAndroid && intensity != null,
    "You can only control torch intensity on iOS");
    assert(_ensureInitialized, '''
      You must initialize your `TorchControl` instance on your runApp().
      You can perform this by adding the following line to your main.dart:
      
      `TorchControl.initialize();`
    ''');

    if (intensity != null) {
      _torchIntensity = intensity;
    }

    try {
      await _channel.invokeMethod('turnOn', [_torchIntensity]);
    } catch (error) {
      if (_debug) {
        debugPrint(error);
      }

      if (!_suppressTorchErrors) {
        rethrow;
      }
    }
  }

  Future<void> off({double intensity}) async {
    assert(_ensureInitialized, '''
      You must initialize your `TorchControl` instance on your runApp().
      You can perform this by adding the following line to your main.dart:
      
      `TorchControl.initialize();`
    ''');

    try {
      await _channel.invokeMethod('turnOff');
    } catch (error) {
      if (_debug) {
        debugPrint(error);
      }

      if (!_suppressTorchErrors) {
        rethrow;
      }
    }
  }
}
