import 'package:flutter_ca/flutter_ca.dart';
import 'package:flutter_ca_example/data/data.dart';

final startups = [Dependency.lazy<ApiDataSource>((_) => ApiDataSource())];
