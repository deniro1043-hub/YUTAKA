import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakure_kanji/features/glyph/kanji_stroke_view.dart';
import 'package:kakure_kanji/main.dart';

void main() {
  testWidgets('ホームから木を開き、画をタップで選択・解除できる', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: KakureKanjiApp()));
    await tester.pumpAndSettle();

    // ゲーム内の漢字は Text ではなく字形描画で表示する（仕様6.3）
    expect(find.text('木'), findsNothing);
    expect(find.byType(KanjiStrokeView), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('tile-26408')));
    await tester.pumpAndSettle();

    final view = find.byKey(const ValueKey('puzzle-kanji'));
    expect(view, findsOneWidget);
    final topLeft = tester.getTopLeft(view);
    final scale = tester.getSize(view).width / 1024;
    Offset at(double x, double y) => topLeft + Offset(x, y) * scale;

    await tester.tapAt(at(498, 800)); // 縦画（2画目）
    await tester.pump();
    expect(find.text('えらんだ画: 2'), findsOneWidget);

    await tester.tapAt(at(300, 372)); // 横画（1画目）
    await tester.pump();
    expect(find.text('えらんだ画: 1, 2'), findsOneWidget);

    await tester.tapAt(at(498, 800)); // もう一度で解除
    await tester.pump();
    expect(find.text('えらんだ画: 1'), findsOneWidget);

    await tester.tap(find.text('えらびなおす'));
    await tester.pump();
    expect(find.textContaining('4画'), findsOneWidget);
  });
}
