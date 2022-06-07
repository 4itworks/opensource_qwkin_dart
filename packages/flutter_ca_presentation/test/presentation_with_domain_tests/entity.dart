import 'package:flutter_ca_domain/flutter_ca_domain.dart';

class Movie extends Entity {
  final String title;

  const Movie(this.title);

  @override
  Entity copyWith({String? title}) {
    return Movie(title ?? this.title);
  }

  @override
  Map<String, dynamic> get map => {'title': title};
}
