import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ca_presentation/src/view_model.dart';
import 'package:provider/provider.dart';

abstract class StatelessView<VM extends ViewModel> extends StatelessWidget {
  const StatelessView({Key? key}) : super(key: key);

  Widget builder(BuildContext context, VM viewModel);

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Consumer<VM>(builder: (ctx, vm, _) => builder(ctx, vm));
  }
}
