import 'package:flutter_ca_domain/flutter_ca_domain.dart';

class Person extends Entity {
  final String name;

  const Person(this.name);

  @override
  Entity copyWith({String? name}) {
    return Person(name ?? this.name);
  }

  @override
  Map<String, dynamic> get map => {'name': name};
}
