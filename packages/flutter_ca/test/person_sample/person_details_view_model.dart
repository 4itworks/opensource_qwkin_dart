import 'package:flutter/foundation.dart';
import 'package:flutter_ca/flutter_ca.dart';

import 'get_person_use_case.dart';
import 'person_entity.dart';
import 'person_repository.dart';

class PersonDetailsViewModel extends ViewModel {
  Person? person;

  final PersonRepository personRepository;

  late final UseCaseWatcher<GetPersonUseCaseResponse> getPersonByIdWatcher;
  late final GetPersonUseCase getPersonByIdUseCase;

  PersonDetailsViewModel(this.personRepository);

  void getPerson() {
    getPersonByIdUseCase(const GetPersonUseCaseParams('123'));
  }

  @override
  void initializeWatchers() {
    getPersonByIdWatcher = UseCaseWatcher<GetPersonUseCaseResponse>(
        onNext: (GetPersonUseCaseResponse? response) {
          person = response?.person;
        },
        onComplete: end,
        onError: (e) {
          if (kDebugMode) {
            print(e);
          }

          end();
        });
  }

  @override
  void initializeUseCases() {
    getPersonByIdUseCase = GetPersonUseCase(getPersonByIdWatcher,
        personRepository: personRepository);
  }
}
