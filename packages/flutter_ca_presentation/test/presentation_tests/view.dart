import 'package:flutter/material.dart';
import 'package:flutter_ca_presentation/flutter_ca_presentation.dart';

import 'view_model.dart';

class CounterView extends StatelessView<CounterViewModel> {
  const CounterView({Key? key}) : super(key: key);

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
