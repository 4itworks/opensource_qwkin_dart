import 'package:flutter_ca/flutter_ca.dart';

import 'person_entity.dart';

class ConcreteDataSource extends DataSource {}

abstract class PersonRepository extends Repository {
  Future<Person> get(String id);
}

class PersonApiRepository extends PersonRepository {
  final ConcreteDataSource dataSource;

  PersonApiRepository(this.dataSource);

  @override
  Future<Person> get(String id) async => const Person('John Doe');
}
