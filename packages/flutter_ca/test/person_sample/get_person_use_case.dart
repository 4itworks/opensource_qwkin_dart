import 'dart:async';

import 'package:flutter_ca/flutter_ca.dart';

import 'person_entity.dart';
import 'person_repository.dart';

class GetPersonUseCaseParams {
  final String id;

  const GetPersonUseCaseParams(this.id);
}

class GetPersonUseCaseResponse {
  final Person person;

  const GetPersonUseCaseResponse(this.person);
}

class GetPersonUseCase
    extends UseCase<GetPersonUseCaseResponse, GetPersonUseCaseParams> {
  final PersonRepository personRepository;

  GetPersonUseCase(UseCaseWatcher<GetPersonUseCaseResponse> useCaseWatcher,
      {required this.personRepository})
      : super(useCaseWatcher);

  @override
  Future<Stream<GetPersonUseCaseResponse>> buildUseCaseStream(
      GetPersonUseCaseParams? params) async {
    final controller = StreamController<GetPersonUseCaseResponse>();

    try {
      final response = await personRepository.get(params!.id);
      controller.add(GetPersonUseCaseResponse(response));
      controller.close();
    } catch (error) {
      controller.addError(error);
    }
    return controller.stream;
  }
}
