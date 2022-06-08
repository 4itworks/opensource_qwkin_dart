import 'package:flutter/foundation.dart';
import 'package:flutter_ca/flutter_ca.dart';

import '../../domain/domain.dart';

class PersonDetailsViewModel extends ViewModel {
  Person? person;

  final PersonRepository personRepository;

  late final UseCaseWatcher<GeneratePersonUseCaseResponse>
      generatePersonByIdWatcher;
  late final GeneratePersonUseCase generatePersonByIdUseCase;

  PersonDetailsViewModel(this.personRepository);

  void generatePerson() {
    start();
    generatePersonByIdUseCase();
  }

  @override
  void initializeWatchers() {
    generatePersonByIdWatcher = UseCaseWatcher<GeneratePersonUseCaseResponse>(
        onNext: (GeneratePersonUseCaseResponse? response) {
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
    generatePersonByIdUseCase = GeneratePersonUseCase(generatePersonByIdWatcher,
        personRepository: personRepository);
  }
}
