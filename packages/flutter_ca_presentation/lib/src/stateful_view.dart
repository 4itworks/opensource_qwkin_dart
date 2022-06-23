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
    extends State<View> with WidgetsBindingObserver{
  late bool _isMounted;

  ViewState() {
    _isMounted = true;
  }

  void inActive(VM viewModel) {}
  void detached(VM viewModel) {}
  void paused(VM viewModel) {}
  void resumed(VM viewModel) {}
  void didChangeViewModel(BuildContext context, VM viewModel) {}

  Widget builder(BuildContext context, VM viewModel);

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Consumer<VM>(builder: (context, viewModel, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) => didChangeViewModel(context, viewModel));
      return builder(context, viewModel);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final viewModel = context.read<VM>();

    if (_isMounted) {
      switch (state) {
        case AppLifecycleState.inactive:
          inActive(viewModel);
          break;
        case AppLifecycleState.paused:
          paused(viewModel);
          break;
        case AppLifecycleState.resumed:
          resumed(viewModel);
          break;
        case AppLifecycleState.detached:
          detached(viewModel);
          break;
      }
    }
  }
}
