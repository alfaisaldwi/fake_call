import 'package:fake_call/core/theme/app_theme.dart';
import 'package:fake_call/core/widgets/top_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<BuildContext> pumpHost(WidgetTester tester) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) {
            captured = context;
            return const Scaffold();
          },
        ),
      ),
    );
    return captured;
  }

  testWidgets('toast muncul di bagian atas lalu hilang sendiri', (
    tester,
  ) async {
    final context = await pumpHost(tester);
    TopToast.show(context, 'Halo dari atas');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    final top = tester.getTopLeft(find.text('Halo dari atas')).dy;
    expect(top, lessThan(100));

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(find.text('Halo dari atas'), findsNothing);
  });

  testWidgets('toast baru menggantikan toast lama', (tester) async {
    final context = await pumpHost(tester);
    TopToast.show(context, 'Pertama');
    await tester.pump();
    TopToast.show(context, 'Kedua', type: ToastType.error);
    await tester.pump();

    expect(find.text('Pertama'), findsNothing);
    expect(find.text('Kedua'), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
