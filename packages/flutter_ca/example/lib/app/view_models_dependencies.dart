import 'package:flutter_ca/flutter_ca.dart';
import 'package:flutter_ca_example/app/view_models/person_details_view_model.dart';
import 'package:flutter_ca_example/data/data.dart';

final viewModels = [
  Dependency.proxy<PersonApiRepository, PersonDetailsViewModel>(
      create: (_) =>
          PersonDetailsViewModel(PersonApiRepository(ApiDataSource())),
      update: (_, personApiRepository, personDetailsViewModel) =>
          PersonDetailsViewModel(personApiRepository)),
];
