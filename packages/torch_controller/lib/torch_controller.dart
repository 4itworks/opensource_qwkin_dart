import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The `TorchController` class presents a global controller to use native torch/flash resources
class TorchController {
  /// Private method channel name
  final _channel = const MethodChannel('torch_control');

  bool _ensureInitialized = false;
  late double _torchIntensity;
  late bool _debug;
  late bool _suppressTorchErrors;

  /// Get current active torch intensity. Only relevant on `iOS`
  double get torchIntensity => _torchIntensity;

  /// Singleton implementation.
  ///
  /// Grants the singleton behavior using this package through app lifecycle
  static final TorchController _singleton = TorchController._internal();
  factory TorchController() {
    return _singleton;
  }
  TorchController._internal();

  /// Initialize configurations that you want to initialize your controller.
  ///
  /// Must be runner on `main.dart` before call `runApp`. It will ensure that the
  /// controller instance will be available within all your app
  ///
  /// - double intensity: Sets the default intensity of the torch. Only relevant on iOS
  /// - debug: Enable/disable debugPrint of error thrown by the methods
  /// - suppressTorchErrors: Suppress native errors from the usage of the torch in different devices. Active this if you
  ///   don't want or need to handle torch errors
  void initialize(
      {double intensity = 1.0,
      bool debug = false,
      bool suppressTorchErrors = false}) async {
    _ensureInitialized = true;
    _debug = debug;
    _torchIntensity = intensity;
    _suppressTorchErrors = suppressTorchErrors;
  }

  /// Return a `bool` if the current device is able to use torch methods.
  ///
  /// You can use this to display something in your app configuration to handle torch usage.
  Future<bool?> get hasTorch async => await _channel.invokeMethod('hasTorch');

  /// Return a `bool` that checks the torch state nativelly.
  ///
  /// You can use this to enable/disable a toggle in it's initial state.
  Future<bool?> get isTorchActive async =>
      await _channel.invokeMethod('isTorchActive');

  /// Execute the action to toggle torch on/off. Returns the current torch state.
  ///
  /// double intensity: Define the desired intensity and set as default. This
  /// parameter is ignored on Android.
  ///
  /// Example:
  ///
  /// final controller = TorchController();
  ///
  /// ```dart
  /// controller.toggle(); // Activates the torch and returns true;
  /// controller.toggle(); // Deactivates the torch and returns false;
  /// ```
  Future<bool?> toggle({double? intensity}) async {
    if (Platform.isAndroid && intensity != null) {
      debugPrint("Warning: Torch intensity is not available on Android");
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
        debugPrint(error.toString());
      }

      if (!_suppressTorchErrors) {
        rethrow;
      }

      return false;
    }
  }
}
