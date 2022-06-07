import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_ca_domain/src/disposable.dart';
import 'package:rxdart/rxdart.dart';

typedef ResponseCallback<T> = void Function(T? t)?;

class UseCaseWatcher<T> {
  ResponseCallback<T> onNext;
  VoidCallback? onComplete;
  ResponseCallback? onError;

  UseCaseWatcher({
    required this.onNext,
    this.onComplete,
    this.onError
  });
}

abstract class UseCase<T, Params> implements Disposable {
  late UseCaseWatcher<T> _watcher;
  late CompositeSubscription _compositeSubscription;

  UseCase(UseCaseWatcher<T> useCaseWatcher) {
    _compositeSubscription = CompositeSubscription();
    _watcher = useCaseWatcher;
  }
  Future<Stream<T?>> buildUseCaseStream(Params? params);

  void call([Params? params]) async {
    final StreamSubscription subscription = (await buildUseCaseStream(params))
        .listen(_watcher.onNext,
        onDone: _watcher.onComplete, onError: _watcher.onError);
    _subscribe(subscription);
  }

  void _subscribe(StreamSubscription subscription) {
    if (_compositeSubscription.isDisposed) {
      _compositeSubscription = CompositeSubscription();
    }
    _compositeSubscription.add(subscription);
  }

  @override
  void dispose() {
    if (!_compositeSubscription.isDisposed) {
      _compositeSubscription.dispose();
    }
  }
}