import 'package:flutter_ca/flutter_ca.dart';
import 'package:flutter_ca_example/data/data.dart';

final repositories = [
  Dependency.lazy<PersonApiRepository>(
      (_) => PersonApiRepository(ApiDataSource()))
];
