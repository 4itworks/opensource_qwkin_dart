import 'dart:math';

import 'package:flutter_ca_example/domain/domain.dart';

class PersonApiRepository<ApiDataSource>
    extends PersonRepository<ApiDataSource> {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final _rnd = Random();
  String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  PersonApiRepository(ApiDataSource dataSource) : super(dataSource);

  @override
  Future<Person> generatePerson() async => Person(name: _getRandomString(10));
}
