import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakure_kanji/features/glyph/kanji_stroke_view.dart';
import 'package:kakure_kanji/main.dart';

import 'glyph/test_glyphs.dart';

void main() {
  // テストごとに FakeAsync のゾーンが変わるため、前のテストで読み込んだ
  // アセットのキャッシュ（Future）を持ち越さない。
  setUp(rootBundle.clear);

  Future<Offset Function(double, double)> openPuzzle(
      WidgetTester tester, int code) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const ProviderScope(child: KakureKanjiApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey('tile-$code')));
    await tester.pumpAndSettle();

    final view = find.byKey(const ValueKey('puzzle-kanji'));
    expect(view, findsOneWidget);
    final topLeft = tester.getTopLeft(view);
    final scale = tester.getSize(view).width / 1024;
    return (x, y) => topLeft + Offset(x, y) * scale;
  }

  String status(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const ValueKey('status-label'))).data!;
  String progress(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const ValueKey('progress-label'))).data!;

  testWidgets('ホームの漢字は字形で描き、Text では表示しない（仕様6.3）', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: KakureKanjiApp()));
    await tester.pumpAndSettle();
    expect(find.text('木'), findsNothing);
    expect(find.byType(KanjiStrokeView), findsWidgets);
  });

  testWidgets('木: 画の選択・解除ができる', (tester) async {
    final at = await openPuzzle(tester, 26408);

    await tester.tapAt(at(498, 800)); // 縦画（2画目）
    await tester.pump();
    expect(status(tester), 'えらんだ画: 2');

    await tester.tapAt(at(300, 372)); // 横画（1画目）
    await tester.pump();
    expect(status(tester), 'えらんだ画: 1, 2');

    await tester.tapAt(at(498, 800)); // もう一度で解除
    await tester.pump();
    expect(status(tester), 'えらんだ画: 1');

    await tester.tap(find.text('えらびなおす'));
    await tester.pump();
    expect(status(tester), contains('4画'));
  });

  testWidgets('木: 十を見つける → 発見演出 → 発見リストに入る', (tester) async {
    final at = await openPuzzle(tester, 26408);
    expect(progress(tester), 'みつけた かず: 0 / 3');

    await tester.tapAt(at(300, 372)); // 1画目
    await tester.tapAt(at(498, 800)); // 2画目
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('check-button')));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const ValueKey('discovery-badge')), findsOneWidget);
    expect(find.text('みつけた！'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('discovery-badge')), findsNothing);

    expect(progress(tester), 'みつけた かず: 1 / 3');
    expect(find.byKey(const ValueKey('found-21313')), findsOneWidget); // 十
    expect(status(tester), contains('4画')); // 選択はリセット

    // 同じ組み合わせをもう一度
    await tester.tapAt(at(300, 372));
    await tester.tapAt(at(498, 800));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('check-button')));
    await tester.pump();
    expect(status(tester), 'それは もう みつけたよ');
    expect(progress(tester), 'みつけた かず: 1 / 3');
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  testWidgets('木: 部品にならない組み合わせは不正解', (tester) async {
    final at = await openPuzzle(tester, 26408);
    await tester.tapAt(at(498, 800)); // 縦画だけ
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('check-button')));
    await tester.pump();
    expect(status(tester), contains('ちがうみたい'));
    expect(progress(tester), 'みつけた かず: 0 / 3');
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });

  testWidgets('林: 正解したら選択は自動で解除され、画は元の黒に戻る', (tester) async {
    final at = await openPuzzle(tester, 26519);
    KanjiStrokeView view() =>
        tester.widget(find.byKey(const ValueKey('puzzle-kanji')));

    final p1 = loadTestGlyph('林').strokeById(1).medianPoints;
    final s1 = p1[p1.length ~/ 2];
    final normal = view().strokeColor;
    await tester.tapAt(at(s1.dx, s1.dy)); // 1画目（左の木の横画）
    await tester.pump();
    expect(status(tester), 'えらんだ画: 1');
    expect(view().selectedStrokeIds, {1});

    await tester.tap(find.byKey(const ValueKey('check-button')));
    await tester.pump();
    // 正解（一）→ もう一度タップしなくても選択は解除されている
    expect(progress(tester), startsWith('みつけた かず: 1 /'));
    expect(view().selectedStrokeIds, isEmpty);

    await tester.pumpAndSettle();
    // 発見演出のあとは、1画目も他の画と同じ色（選択前の黒）
    expect(view().highlightStrokeIds, isEmpty);
    final painter = KanjiStrokePainter(
      glyph: view().glyph,
      selectedStrokeIds: view().selectedStrokeIds,
      highlightStrokeIds: view().highlightStrokeIds,
      strokeColor: normal,
      selectedColor: view().selectedColor,
      showGrid: false,
      gridColor: view().gridColor,
    );
    for (final s in view().glyph.strokes) {
      expect(painter.colorFor(s.id), normal, reason: '${s.id}画目');
    }
  });

  testWidgets('選択を手で解除した画も、選択前の黒に戻る', (tester) async {
    final at = await openPuzzle(tester, 26519);
    KanjiStrokeView view() =>
        tester.widget(find.byKey(const ValueKey('puzzle-kanji')));
    final p1 = loadTestGlyph('林').strokeById(1).medianPoints;
    final s1 = p1[p1.length ~/ 2];
    await tester.tapAt(at(s1.dx, s1.dy));
    await tester.pump();
    expect(view().selectedStrokeIds, {1});
    await tester.tapAt(at(s1.dx, s1.dy));
    await tester.pump();
    expect(view().selectedStrokeIds, isEmpty);
    expect(view().highlightStrokeIds, isEmpty);
  });
}
