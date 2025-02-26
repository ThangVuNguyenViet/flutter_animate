import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../tester_extensions.dart';

void main() {
  testWidgets('swap Logo for a Placeholder', (tester) async {
    final anim = const FlutterLogo().animate().fadeOut(duration: 500.ms).swap(
          builder: (_, __) => const Placeholder().animate().fadeIn(),
        );
    await tester.pumpAnimation(anim);
    // Initially, expect one FlutterLogo, no Placeholder
    expect(find.byType(FlutterLogo), findsOneWidget);
    expect(find.byType(Placeholder), findsNothing);
    // At the end, expect one Placeholder, no FlutterLogo
    await tester.pump(500.ms);
    await tester.pump(0.ms); // clear out the callback
    expect(find.byType(Placeholder), findsOneWidget);
    expect(find.byType(FlutterLogo), findsNothing);
  });

  testWidgets('Fade a logo out and back in using swap()', (tester) async {
    final anim = const FlutterLogo().animate().fadeOut(duration: 500.ms).swap(
          builder: (_, originalChild) =>
              originalChild!.animate().fadeIn(duration: 500.ms),
        );
    await tester.pumpAnimation(anim);
    // Initially, faded in
    tester.expectWidgetWithDouble<FadeTransition>(
        (w) => w.opacity.value, 1, 'opacity');
    // halfway, check fadeOut
    await tester.pump(500.ms);
    await tester.pump(0.ms);
    tester.expectWidgetWithDouble<FadeTransition>(
        (w) => w.opacity.value, 0, 'opacity');
    // end, check fadeIn
    await tester.pump(500.ms);
    await tester.pump(0.ms);
    tester.expectWidgetWithDouble<FadeTransition>(
        (w) => w.opacity.value, 1, 'opacity');
  });
}
