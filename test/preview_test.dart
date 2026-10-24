// Captures real Flutter-rendered screens. Run with flutter test --update-goldens.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_event_explorer/main.dart';

void main() {
  testWidgets('four submission preview screens', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final loader = FontLoader('Outfit')
      ..addFont(rootBundle.load('assets/fonts/Outfit.ttf'));
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    await tester.pumpWidget(
      const RepaintBoundary(key: Key('preview'), child: CampusApp()),
    );
    await tester.runAsync(() async {
      final context = tester.element(find.byType(MaterialApp));
      for (final name in ['technology', 'arts', 'sports']) {
        await precacheImage(AssetImage('assets/images/$name.png'), context);
      }
    });
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('preview')),
      matchesGoldenFile('../docs/screenshots/explore.png'),
    );
    await tester.tap(find.text('Build Something Brilliant').first);
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('preview')),
      matchesGoldenFile('../docs/screenshots/details.png'),
    );
    await tester.tap(find.byTooltip('Add favorite'));
    await tester.tap(find.text('Join event'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favorites').last);
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('preview')),
      matchesGoldenFile('../docs/screenshots/favorites.png'),
    );
    await tester.tap(find.text('My Events').last);
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('preview')),
      matchesGoldenFile('../docs/screenshots/my-events.png'),
    );
  });
}
