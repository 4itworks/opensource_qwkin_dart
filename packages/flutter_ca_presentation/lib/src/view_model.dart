import 'package:flutter/foundation.dart';
import 'package:flutter_ca_domain/flutter_ca_domain.dart';

abstract class ViewModel extends Disposable with ChangeNotifier {
  @mustCallSuper
  ViewModel() {
    initListeners();
  }

  void initListeners() {}
}
