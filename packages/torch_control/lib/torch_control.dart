import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TorchController {
  final _channel = const MethodChannel('torch_control');

  bool _ensureInitialized = false;
  double _torchIntensity;
  bool _debug;
  bool _suppressTorchErrors;

  double get torchIntensity => _torchIntensity;

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
    _debug = debug;
    _torchIntensity = intensity;
    _suppressTorchErrors = suppressTorchErrors;
  }

  Future<bool> get hasTorch async => await _channel.invokeMethod('hasTorch');

  Future<bool> get isTorchActive async =>
      await _channel.invokeMethod('isTorchActive');

  Future<bool> toggle({double intensity}) async {
    if (Platform.isAndroid && intensity != null) {
      throw (AssertionError("You can only control torch intensity on iOS"));
    }

    if (intensity != null) {
      assert(intensity > 0 && intensity <= 1,
          "You can only use values between 0 and 1");
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

      return await _channel.invokeMethod('toggleTorch', _torchIntensity);
    } catch (error) {
      if (_debug) {
        debugPrint(error);
      }

      if (!_suppressTorchErrors) {
        rethrow;
      }

      return false;
    }
  }
}
