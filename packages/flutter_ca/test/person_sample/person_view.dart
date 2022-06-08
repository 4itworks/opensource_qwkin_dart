import 'package:flutter/material.dart';
import 'package:flutter_ca/flutter_ca.dart';

import 'person_details_view_model.dart';

class PersonView extends StatelessView<PersonDetailsViewModel> {
  const PersonView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, PersonDetailsViewModel viewModel) {
    return Scaffold(
      key: GlobalKey(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(viewModel.person?.name ?? 'No Person'),
            MaterialButton(
              onPressed: viewModel.getPerson,
              child: const Text('Fetch Person'),
            ),
          ],
        ),
      ),
    );
  }
}
