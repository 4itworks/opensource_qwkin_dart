import 'dart:async';

import 'package:flutter_ca/flutter_ca.dart';
import 'package:flutter_ca_example/domain/entities/person_entity.dart';
import 'package:flutter_ca_example/domain/repositories/person_repository.dart';

class GeneratePersonUseCaseResponse {
  final Person person;

  const GeneratePersonUseCaseResponse(this.person);
}

class GeneratePersonUseCase
    extends UseCase<GeneratePersonUseCaseResponse, void> {
  final PersonRepository personRepository;

  GeneratePersonUseCase(
      UseCaseWatcher<GeneratePersonUseCaseResponse> useCaseWatcher,
      {required this.personRepository})
      : super(useCaseWatcher);

  @override
  Future<Stream<GeneratePersonUseCaseResponse>> buildUseCaseStream(
      params) async {
    final controller = StreamController<GeneratePersonUseCaseResponse>();

    try {
      final response = await personRepository.generatePerson();
      controller.add(GeneratePersonUseCaseResponse(response));
      controller.close();
    } catch (error) {
      controller.addError(error);
    }
    return controller.stream;
  }
}
