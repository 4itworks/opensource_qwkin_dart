import 'package:flutter_ca_domain/flutter_ca_domain.dart';

import 'entity.dart';

class GetMovieUseCase extends UseCase<Movie, void> {
  GetMovieUseCase(UseCaseWatcher<Movie> useCaseWatcher) : super(useCaseWatcher);

  @override
  Future<Stream<Movie>> buildUseCaseStream(params) async {
    return Stream<Movie>.value(const Movie('Spider-man'));
  }
}

class GetMovieUseCaseError extends UseCase<Movie, void> {
  GetMovieUseCaseError(UseCaseWatcher<Movie> useCaseWatcher)
      : super(useCaseWatcher);

  @override
  Future<Stream<Movie>> buildUseCaseStream(params) async {
    return Stream.error(Error());
  }
}
