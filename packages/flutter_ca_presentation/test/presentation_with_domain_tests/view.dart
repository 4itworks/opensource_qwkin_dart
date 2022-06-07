import 'package:flutter/material.dart';
import 'package:flutter_ca_presentation/flutter_ca_presentation.dart';

import 'view_model.dart';

class MovieView extends StatelessView<MovieViewModel> {
  const MovieView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, MovieViewModel viewModel) {
    return Scaffold(
      key: GlobalKey(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(viewModel.movie?.title ?? 'No Movie'),
            MaterialButton(
              onPressed: viewModel.fetchMovie,
              child: const Text('Fetch Movie'),
            ),
          ],
        ),
      ),
    );
  }
}
