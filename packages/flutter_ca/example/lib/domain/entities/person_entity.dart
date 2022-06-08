import 'package:flutter_ca/flutter_ca.dart';

class Person extends Entity {
  final String name;

  const Person({required this.name});

  @override
  Entity copyWith({String? name}) => Person(name: name ?? this.name);

  @override
  Map<String, dynamic> get map => {'name': name};
}
