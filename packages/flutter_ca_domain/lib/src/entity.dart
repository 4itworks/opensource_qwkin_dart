import 'package:flutter/foundation.dart';

@immutable
abstract class Entity {
  const Entity();

  Map<String, dynamic> get map;
  Entity copyWith();
  @override
  String toString() {
    return map.toString();
  }
}
