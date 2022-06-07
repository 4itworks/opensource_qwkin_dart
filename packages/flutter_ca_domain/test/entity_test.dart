import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_ca_domain/flutter_ca_domain.dart';

class ImplementedEntity extends Entity {
  @override
  ImplementedEntity copyWith() => ImplementedEntity();

  @override
  Map<String, dynamic> get map => {};
}

void main() {
  test('Test abstract entity methods', () {
    final entity = ImplementedEntity();
    expect(entity.copyWith(), isInstanceOf<ImplementedEntity>());
    expect(entity.map, equals({}));
    expect(entity.toString(), equals('{}'));
  });
}
