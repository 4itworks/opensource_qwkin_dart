import 'package:flutter_ca_presentation/flutter_ca_presentation.dart';

class CounterViewModel extends ViewModel {
  int value;

  CounterViewModel([this.value = 0]);

  void incrementCounter() {
    value++;
    notifyListeners();
  }

  void decrementCounter() {
    value--;
    notifyListeners();
  }
}