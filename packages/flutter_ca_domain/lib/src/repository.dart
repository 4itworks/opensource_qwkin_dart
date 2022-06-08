import 'package:flutter/cupertino.dart';

abstract class Repository<DataSource> with ChangeNotifier {
  final DataSource dataSource;

  Repository(this.dataSource);
}
