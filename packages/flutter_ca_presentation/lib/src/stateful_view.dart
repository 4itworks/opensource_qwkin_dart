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

  void onDidChangeDependencies(VM viewModel) {}
  void onInitState(VM viewModel) {}
  void onInActive(VM viewModel) {}
  void onDetached(VM viewModel) {}
  void onPaused(VM viewModel) {}
  void onResumed(VM viewModel) {}

  Widget builder(BuildContext context, VM viewModel);

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Consumer<VM>(builder: (ctx, vm, _) => builder(ctx, vm));
  }

  @override
  @nonVirtual
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onDidChangeDependencies(context.read<VM>());
    });
  }

  @override
  @nonVirtual
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onInitState(context.read<VM>());
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final viewModel = context.read<VM>();

    if (_isMounted) {
      switch (state) {
        case AppLifecycleState.inactive:
          onInActive(viewModel);
          break;
        case AppLifecycleState.paused:
          onPaused(viewModel);
          break;
        case AppLifecycleState.resumed:
          onResumed(viewModel);
          break;
        case AppLifecycleState.detached:
          onDetached(viewModel);
          break;
      }
    }
  }
}
