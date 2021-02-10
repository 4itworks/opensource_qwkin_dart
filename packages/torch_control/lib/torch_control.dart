import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TorchController {
  final _channel = const MethodChannel('torch_control');

  bool _ensureInitialized = false;
  double _torchIntensity;
  bool _debug;
  bool _isTorchOn;
  bool _suppressTorchErrors;

  double get torchIntensity => _torchIntensity;
  bool get isTorchOn => _isTorchOn;

  static final TorchController _singleton = TorchController._internal();
  factory TorchController() {
    return _singleton;
  }
  TorchController._internal();

  void initialize(
      {double intensity = 1.0,
      bool debug = false,
      bool suppressTorchErrors = false}) async {
    _ensureInitialized = true;
    _isTorchOn = false;
    _debug = debug;
    _torchIntensity = intensity;
    _suppressTorchErrors = suppressTorchErrors;
  }

  Future<bool> get hasTorch async => await _channel.invokeMethod('hasTorch');

  Future<void> on({double intensity}) async {
    if (Platform.isAndroid && intensity != null) {
      throw (AssertionError("You can only control torch intensity on iOS"));
    }
    assert(_ensureInitialized, '''
      You must initialize your `TorchControl` instance on your runApp().
      You can perform this by adding the following line to your main.dart:
      
      `TorchControl.initialize();`
    ''');

    try {
      if (intensity != null) {
        _torchIntensity = intensity;
      }

      await _channel.invokeMethod('turnOn', [_torchIntensity]);

      _isTorchOn = true;
    } catch (error) {
      if (_debug) {
        debugPrint(error);
      }

      if (!_suppressTorchErrors) {
        rethrow;
      }
    }
  }

  Future<void> off() async {
    assert(_ensureInitialized, '''
      You must initialize your `TorchControl` instance on your runApp().
      You can perform this by adding the following line to your main.dart:
      
      `TorchControl.initialize();`
    ''');

    try {
      await _channel.invokeMethod('turnOff');
      _isTorchOn = false;
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
