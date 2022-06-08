import 'package:flutter/foundation.dart';
import 'package:flutter_ca_domain/flutter_ca_domain.dart';

abstract class ViewModel extends Disposable with ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;

  void _setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void start() => _setBusy(true);
  void end() => _setBusy(false);

  @mustCallSuper
  ViewModel() {
    initListeners();
  }

  void initListeners() {}
}
