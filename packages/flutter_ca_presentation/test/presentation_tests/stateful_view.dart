import 'package:flutter/material.dart';
import 'package:flutter_ca_presentation/flutter_ca_presentation.dart';
import 'package:flutter_ca_presentation/src/stateful_view.dart';

import 'view_model.dart';

class StatefulCounterView extends StatefulView {
  const StatefulCounterView({Key? key}) : super(key: key);

  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState
    extends ViewState<StatefulCounterView, CounterViewModel> {

  @override
  void didChangeViewModel(BuildContext context, CounterViewModel viewModel) {
    print(viewModel.value);
  }

  @override
  Widget builder(BuildContext context, CounterViewModel viewModel) {
    return Scaffold(
      key: GlobalKey(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(viewModel.value.toString()),
            MaterialButton(
              onPressed: viewModel.incrementCounter,
              child: const Text('Increase'),
            ),
            MaterialButton(
              onPressed: viewModel.decrementCounter,
              child: const Text('Decrease'),
            )
          ],
        ),
      ),
    );
  }
}
