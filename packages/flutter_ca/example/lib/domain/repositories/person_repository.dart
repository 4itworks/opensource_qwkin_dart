import 'package:flutter_ca/flutter_ca.dart';
import 'package:flutter_ca_example/domain/entities/person_entity.dart';

abstract class PersonRepository<T> extends Repository<T> {
  PersonRepository(T dataSource) : super(dataSource);

  Future<Person> generatePerson();
}
