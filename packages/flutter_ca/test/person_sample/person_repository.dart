import 'package:flutter/cupertino.dart';
import 'package:flutter_ca_domain/flutter_ca_domain.dart';

import 'person_entity.dart';

class DataSource with ChangeNotifier {}

abstract class PersonRepository<DataSource> extends Repository<DataSource> {
  PersonRepository(DataSource dataSource) : super(dataSource);

  Future<Person> get(String id);
}

class PersonApiRepository extends PersonRepository<DataSource> {
  PersonApiRepository(DataSource dataSource) : super(dataSource);

  @override
  Future<Person> get(String id) async => const Person('John Doe');
}
