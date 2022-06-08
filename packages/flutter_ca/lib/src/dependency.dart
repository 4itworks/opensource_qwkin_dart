import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Dependency {
  static ChangeNotifierProvider value<T extends ChangeNotifier>(
          {required T value}) =>
      ChangeNotifierProvider<T>.value(value: value);
  static ChangeNotifierProvider single<T extends ChangeNotifier>(
          T Function(BuildContext) create) =>
      ChangeNotifierProvider<T>(create: create);
  static ChangeNotifierProvider lazy<T extends ChangeNotifier>(
          T Function(BuildContext) create) =>
      ChangeNotifierProvider<T>(create: create, lazy: true);
  static ChangeNotifierProxyProvider<T, V> proxy<T, V extends ChangeNotifier>(
          {bool lazy = true,
          required V Function(BuildContext) create,
          required V Function(BuildContext, T, V?) update}) =>
      ChangeNotifierProxyProvider<T, V>(
        create: create,
        update: update,
        lazy: lazy,
      );
  static ChangeNotifierProxyProvider2<T, T1, V>
      proxy2<T, T1, V extends ChangeNotifier>(
              {bool lazy = true,
              required V Function(BuildContext) create,
              required V Function(BuildContext, T, T1, V?) update}) =>
          ChangeNotifierProxyProvider2<T, T1, V>(
            create: create,
            update: update,
            lazy: lazy,
          );
  static ChangeNotifierProxyProvider3<T, T1, T2, V>
      proxy3<T, T1, T2, V extends ChangeNotifier>(
              {bool lazy = true,
              required V Function(BuildContext) create,
              required V Function(BuildContext, T, T1, T2, V?) update}) =>
          ChangeNotifierProxyProvider3<T, T1, T2, V>(
            create: create,
            update: update,
            lazy: lazy,
          );
}
