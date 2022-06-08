import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DependencyInjector extends StatelessWidget {
  final List<SingleChildWidget> startups;
  final List<SingleChildWidget> repositories;
  final List<SingleChildWidget> viewModels;
  final Widget child;

  const DependencyInjector(
      {Key? key,
      required this.child,
      this.startups = const [],
      this.repositories = const [],
      this.viewModels = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [...startups, ...repositories, ...viewModels],
      child: child,
    );
  }
}
