import 'package:flutter/foundation.dart';

abstract class ViewModel with ChangeNotifier {
  bool _initialized = false;
  bool _busy = false;
  bool get busy => _busy;

  void _setBusy(bool value) {
    if (_initialized) {
      _busy = value;
      notifyListeners();
    }
  }

  void start() => _setBusy(true);
  void end() => _setBusy(false);

  @mustCallSuper
  ViewModel() {
    _initialized = true;
    initializeWatchers();
    initializeUseCases();
  }

  void initializeWatchers() {}
  void initializeUseCases() {}

  @override
  void dispose() {
    _initialized = false;
    super.dispose();
  }
}
