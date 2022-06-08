import 'package:flutter_ca_example/data/data_sources/api_data_source.dart';
import 'package:flutter_ca_example/domain/domain.dart';

class PersonApiRepository extends PersonRepository {
  final ApiDataSource apiDataSource;

  PersonApiRepository(this.apiDataSource);

  @override
  Future<Person> generatePerson() async =>
      Person(name: apiDataSource.getRandomString(10));
}
