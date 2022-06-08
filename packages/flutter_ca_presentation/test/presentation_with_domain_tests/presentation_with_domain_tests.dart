import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'view.dart';
import 'view_model.dart';

void main() {
  Widget widget = MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MovieViewModel())
      ],
      child: MaterialApp(
        home: Builder(builder: (_) => const MovieView()),
      ));

  testWidgets('Should render CounterView', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(find.byType(MovieView), findsOneWidget);
    expect(find.text('No Movie'), findsOneWidget);
    expect(find.text('Fetch Movie'), findsOneWidget);
  });

  testWidgets('Should execute changes on view', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    final fetchButton = find.text('Fetch Movie');

    expect(fetchButton, findsOneWidget);
    expect(find.text('No Movie'), findsOneWidget);

    await tester.tap(fetchButton);
    await tester.pumpAndSettle();
    expect(find.text('Spider-man'), findsOneWidget);
  });
}
