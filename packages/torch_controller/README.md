[![melos](https://img.shields.io/badge/maintained%20with-melos-f700ff.svg?style=flat-square)](https://github.com/invertase/melos)

<p align="center">
  <img src="https://raw.githubusercontent.com/4itworks/opensource_qwkin_dart/master/.github/os.png?sanitize=true" width="350px">
</p>

#torch_controller
A flutter plugin wrote to control `torch/flash` of the device.

### Disclaimer
- For now, the package is only available for `iOS`. Android version will
be released until `1.0.0` version

### Installing
- Add `torch_controller: 0.1.2` to your pubspec.yaml

### Usage

To use this package, some steps are required. Please follow the instructions below:

- Initialize `TorchController` by calling `TorchController().initialize()` 
before your `runApp` on your `main.dart` file.
- Now, to use the package, just initiate the controller like:
```dart
/// Returns a singleton with the controller that you had initialized
/// on `main.dart`
final torchController = TorchController();
```
- To toggle (on/off) torch, just call:
```dart
/// This will toggle lights and return the current state
bool active = torchController.toggle();
```
- You can check more specific docs right on methods documentation

### Authors
- [Rafael Carvalho Monteiro](https://github.com/rafaelcmm)