import 'package:flutter/material.dart';
import 'package:flutter_ca/flutter_ca.dart';
import 'package:flutter_ca_example/app/repositories_dependencies.dart';
import 'package:flutter_ca_example/app/startup_dependencies.dart';
import 'package:flutter_ca_example/app/view_models_dependencies.dart';
import 'package:flutter_ca_example/app/views/person_details_view.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
        startups: startups,
        repositories: repositories,
        viewModels: viewModels,
        child: const MaterialApp(
          home: PersonDetailsView(),
        ));
  }
}
