import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ca_presentation/flutter_ca_presentation.dart';
import 'package:provider/provider.dart';

abstract class StatefulView extends StatefulWidget {
  @override
  final Key? key;
  final RouteObserver? routeObserver;

  const StatefulView({this.routeObserver, this.key}) : super(key: key);
}

abstract class ViewState<View extends StatefulView, VM extends ViewModel>
    extends State<View> {

  Widget builder(BuildContext context, VM viewModel);

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Consumer<VM>(builder: (ctx, vm, _) => builder(ctx, vm));
  }
}