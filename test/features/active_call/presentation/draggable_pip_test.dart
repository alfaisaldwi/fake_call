import 'package:fake_calling/features/active_call/presentation/widgets/draggable_pip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const pipKey = Key('pip');
  const size = Size(100, 150);
  const margin = EdgeInsets.all(16);

  Future<void> pumpPip(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DraggablePip(
            size: size,
            margin: margin,
            child: SizedBox(key: pipKey, width: 100, height: 150),
          ),
        ),
      ),
    );
  }

  testWidgets('awalnya di kanan bawah', (tester) async {
    await pumpPip(tester);

    expect(tester.getTopLeft(find.byKey(pipKey)), const Offset(284, 634));
  });

  testWidgets('tahan lalu geser memindahkan ke sudut terdekat', (tester) async {
    await pumpPip(tester);
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(pipKey)),
    );
    await tester.pump(
      DraggablePip.holdDuration + const Duration(milliseconds: 50),
    );
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(-28, -60));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await tester.pump(const Duration(milliseconds: 300));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byKey(pipKey)), const Offset(16, 16));
  });

  testWidgets('geser tanpa ditahan tidak memindahkan', (tester) async {
    await pumpPip(tester);
    await tester.drag(find.byKey(pipKey), const Offset(-250, -500));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byKey(pipKey)), const Offset(284, 634));
  });
}
