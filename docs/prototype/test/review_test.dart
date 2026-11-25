import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savemargin_prototype/main.dart';

void main() {
  testWidgets('A private phone draft becomes a public score only on publish', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 850);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const Prototype());
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    await tester.enterText(find.byType(TextField), 'Запомнился шум моря.');
    await tester.tap(find.text('Сохранить черновик'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Вид гостя'));
    await tester.pumpAndSettle();
    expect(find.text('Пока нет опубликованной рецензии.'), findsOneWidget);
    await tester.pageBackOrPop();
    await tester.pumpAndSettle();
    // Reopening the client must restore the saved draft.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(const Prototype());
    expect(find.text('Запомнился шум моря.'), findsOneWidget);
    tester.view.physicalSize = const Size(1040, 900);
    await tester.tap(find.text('Обновить часы'));
    await tester.pumpAndSettle();
    final score = find.widgetWithText(ChoiceChip, '7,5');
    await tester.ensureVisible(score);
    await tester.tap(score);
    await tester.tap(find.byType(CheckboxListTile));
    await tester.tap(find.text('Опубликовать'));
    await tester.pumpAndSettle();
    expect(find.text('7,5'), findsOneWidget);
    expect(find.text('Steam · 90 мин на момент публикации'), findsOneWidget);
    expect(find.text('Запомнился шум моря.'), findsNothing);
    await tester.tap(find.text('Показать спойлер'));
    await tester.pump();
    expect(find.text('Запомнился шум моря.'), findsOneWidget);
  });
}

extension on WidgetTester {
  Future<void> pageBackOrPop() async {
    state<NavigatorState>(find.byType(Navigator)).pop();
  }
}
