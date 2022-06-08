import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Dependency {
  static ChangeNotifierProvider value<T extends ChangeNotifier>(T value) =>
      ChangeNotifierProvider.value(value: value);
  static ChangeNotifierProvider lazy(
          ChangeNotifier? Function(BuildContext) builder) =>
      ChangeNotifierProvider(create: builder, lazy: true);
  static ProxyProvider<T, V> proxy<T, V extends ChangeNotifier>(
          V Function(BuildContext, T, V?) builder,
          {bool lazy = true}) =>
      ProxyProvider<T, V>(
        update: builder,
        lazy: lazy,
      );
  static ProxyProvider2<T, T1, V> proxy2<T, T1, V extends ChangeNotifier>(
          V Function(BuildContext, T, T1, V?) builder,
          {bool lazy = true}) =>
      ProxyProvider2<T, T1, V>(
        update: builder,
        lazy: lazy,
      );
  static ProxyProvider3<T, T1, T2, V>
      proxy3<T, T1, T2, V extends ChangeNotifier>(
              V Function(BuildContext, T, T1, T2, V?) builder,
              {bool lazy = true}) =>
          ProxyProvider3<T, T1, T2, V>(
            update: builder,
            lazy: lazy,
          );
}
