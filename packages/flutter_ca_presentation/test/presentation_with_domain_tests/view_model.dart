import 'package:flutter_ca_domain/flutter_ca_domain.dart';
import 'package:flutter_ca_presentation/flutter_ca_presentation.dart';

import 'entity.dart';
import 'get_movie_use_case.dart';

class MovieViewModel extends ViewModel {
  late final GetMovieUseCase getMovieUseCase;

  Movie? movie;

  void fetchMovie() {
    getMovieUseCase();
  }

  @override
  void initializeUseCases() {
    getMovieUseCase = GetMovieUseCase(UseCaseWatcher(onNext: (Movie? m) {
      movie = m;
      notifyListeners();
    }));
  }
}
