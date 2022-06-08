import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_ca/flutter_ca.dart';

import 'person_sample/person_details_view_model.dart';
import 'person_sample/person_repository.dart';
import 'person_sample/person_view.dart';

void main() {
  final widget = DependencyInjector(
      startups: [
        Dependency.single<ConcreteDataSource>((_) => ConcreteDataSource())
      ],
      repositories: [
        Dependency.lazy<PersonApiRepository>(
            (_) => PersonApiRepository(ConcreteDataSource()))
      ],
      viewModels: [
        Dependency.lazy<PersonDetailsViewModel>((_) =>
            PersonDetailsViewModel(PersonApiRepository(ConcreteDataSource())))
      ],
      child: const MaterialApp(
        home: PersonView(),
      ));

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Should render PersonView', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    expect(find.byType(PersonView), findsOneWidget);
    expect(find.text('No Person'), findsOneWidget);
    expect(find.text('Fetch Person'), findsOneWidget);
  });

  testWidgets('Should execute changes on view', (WidgetTester tester) async {
    await tester.pumpWidget(widget);

    final fetchButton = find.text('Fetch Person');

    expect(fetchButton, findsOneWidget);
    expect(find.text('No Person'), findsOneWidget);

    await tester.tap(fetchButton);
    await tester.pumpAndSettle();
    expect(find.text('John Doe'), findsOneWidget);
  });
}
