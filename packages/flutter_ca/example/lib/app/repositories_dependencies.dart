import 'package:flutter_ca/flutter_ca.dart';
import 'package:flutter_ca_example/data/data.dart';
import 'package:provider/single_child_widget.dart';

final repositories = <SingleChildWidget>[
  Dependency.proxy<ApiDataSource, PersonApiRepository>(
      create: (_) => PersonApiRepository(ApiDataSource()),
      update: (_, apiDataSource, personApiRepository) =>
          PersonApiRepository(apiDataSource))
];
