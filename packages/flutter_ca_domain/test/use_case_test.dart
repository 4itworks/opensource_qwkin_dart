import 'package:flutter_ca_domain/flutter_ca_domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UseCase test scenarios', () {
    var number = -1;
    var done = false;
    var error = false;

    final counterUseCaseWatcher = UseCaseWatcher<int>(onNext: (int? n) {
      number++;
      expect(number, equals(n));
    }, onComplete: () {
      done = true;
    }, onError: (e) {
      error = true;
    });

    final counterUseCase = CounterUseCase(counterUseCaseWatcher);
    final counterUseCaseError = CounterUseCaseError(counterUseCaseWatcher);

    test('UseCase onNext and onDone.', () async {
      counterUseCase();

      await Future.delayed(const Duration(milliseconds: 1000), () {
        expect(done, true);
        expect(error, false);
      });
    });

    test('UseCase .OnError.', () async {
      counterUseCaseError();

      await Future.delayed(const Duration(milliseconds: 1000), () {
        expect(done, true);
        expect(error, true);
      });
    });

    test('UseCase .dispose cancels the subscription', () async {
      await Future.delayed(const Duration(milliseconds: 15), () {
        counterUseCase.dispose();
        counterUseCaseError.dispose();
      });
    });
  });
}

class CounterUseCase extends UseCase<int, void> {
  CounterUseCase(UseCaseWatcher<int> useCaseWatcher) : super(useCaseWatcher);

  @override
  Future<Stream<int>> buildUseCaseStream(void params) async {
    return Stream.periodic(const Duration(milliseconds: 10), (i) => i).take(3);
  }
}

class CounterUseCaseError extends UseCase<int, void> {
  CounterUseCaseError(UseCaseWatcher<int> useCaseWatcher)
      : super(useCaseWatcher);

  @override
  Future<Stream<int>> buildUseCaseStream(void params) async {
    return Stream.error(Error());
  }
}
