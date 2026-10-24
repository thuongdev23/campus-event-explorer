import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/main.dart';
import 'package:campus_event_explorer/controllers/event_controller.dart';

void main() {
  test(
    'data invariants, combined filters, favorites and idempotent capacity',
    () {
      final c = EventController();
      expect(c.events.length, greaterThanOrEqualTo(6));
      expect(c.events.map((e) => e.id).toSet().length, c.events.length);
      expect(c.categories.length, greaterThanOrEqualTo(4));
      for (final e in c.events) {
        expect(e.dateTime.isAfter(DateTime(2026, 10, 25, 23, 59)), true);
        expect(c.available(e), inInclusiveRange(0, e.capacity));
      }
      final full = c.events.firstWhere((e) => e.initialAvailable == 0);
      expect(c.join(full), false);
      final last = c.events.firstWhere((e) => e.initialAvailable == 1);
      c.toggleFavorite(last);
      expect(c.available(last), 1);
      expect(c.joinedCount, 0);
      expect(c.join(last), true);
      expect(c.join(last), false);
      expect(c.available(last), 0);
      expect(c.joinedCount, 1);
      c.query = '  AFTER HOURS  ';
      c.category = 'Arts';
      for (final tab in EventTab.values) {
        c.tab = tab;
        expect(c.visibleEvents.single, last);
      }
      c.category = 'Sports';
      expect(c.visibleEvents, isEmpty);
      expect(c.cancel(last), true);
      expect(c.cancel(last), false);
      expect(c.available(last), 1);
      expect(c.joinedCount, 0);
    },
  );

  testWidgets(
    'dialogs, navigation, shared collections, empty search and image viewer',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const CampusApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Build Something Brilliant').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Join event'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Innovation Lab').last, findsOneWidget);
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();
      expect(find.text('Join event'), findsOneWidget);
      await tester.tap(find.text('Join event'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(8, 100));
      await tester.pumpAndSettle();
      expect(find.text('Join event'), findsOneWidget);
      await tester.tap(find.text('Join event'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel participation'), findsOneWidget);
      await tester.tap(find.text('Cancel participation'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel participation'), findsOneWidget);
      await tester.tap(find.byTooltip('Add favorite'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Double-tap image to enlarge'));
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveViewer), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel participation'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(find.text('Join event'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Favorites').last);
      await tester.pumpAndSettle();
      expect(find.text('Build Something Brilliant'), findsOneWidget);
      await tester.enterText(find.byType(TextField), ' no such event ');
      await tester.pumpAndSettle();
      expect(find.text('No events match your filters.'), findsOneWidget);
      await tester.tap(find.text('My Events').last);
      await tester.pumpAndSettle();
      expect(find.text(' no such event '), findsOneWidget);
      await tester.tap(find.text('Clear search & filters'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Your next experience is waiting'),
        findsOneWidget,
      );
    },
  );
  testWidgets(
    'full event disabled, last-place cancellation and double-tap viewer',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const CampusApp());
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Sunrise');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sunrise on the Court'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sunrise on the Court'));
      await tester.pumpAndSettle();
      final fullButton = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(fullButton.onPressed, isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'After Hours');
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('After Hours: Campus Sessions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('After Hours: Campus Sessions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Join event'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(find.text('Cancel participation'), findsOneWidget);
      await tester.tap(find.byType(Image).first);
      await tester.pump(const Duration(milliseconds: 70));
      await tester.tap(find.byType(Image).first);
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveViewer), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel participation'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(find.text('Join event'), findsOneWidget);
      expect(
        find.text('1 place remaining / 80 total capacity'),
        findsOneWidget,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('0 joined'), findsOneWidget);
    },
  );

  testWidgets('small phone remains usable', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const CampusApp());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Build Something Brilliant'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Build Something Brilliant').first);
    await tester.pumpAndSettle();
    expect(find.text('Join event'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
