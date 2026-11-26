import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakure_kanji/features/glyph/kanji_stroke_view.dart';
import 'package:kakure_kanji/features/glyph/stroke_hit_tester.dart';

import 'test_glyphs.dart';

void main() {
  final ki = loadTestGlyph('木');

  test('木: 各画の上をタップするとその画が選ばれる', () {
    expect(hitTestStroke(ki, const Offset(300, 372)), 1); // 横画
    expect(hitTestStroke(ki, const Offset(498, 800)), 2); // 縦画
    expect(hitTestStroke(ki, const Offset(240, 676)), 3); // 左払い
    expect(hitTestStroke(ki, const Offset(850, 715)), 4); // 右払い
  });

  test('画から離れた場所は何も選ばれない', () {
    expect(hitTestStroke(ki, const Offset(60, 60)), isNull);
    expect(hitTestStroke(ki, const Offset(960, 100)), isNull);
  });

  test('ウィジェット座標から字形座標への変換（中央寄せ・等倍率）', () {
    const size = Size(200, 100); // 正方形に収めると 100x100, 左右に 50 の余白
    expect(toGlyphSpace(const Offset(50, 0), size), Offset.zero);
    expect(toGlyphSpace(const Offset(100, 50), size), const Offset(512, 512));
  });

  test('仕様6.4: 選択中の画は最後（最前面）に描く', () {
    final painter = KanjiStrokePainter(
      glyph: ki,
      selectedStrokeIds: const {1, 3},
      strokeColor: const Color(0xFF000000),
      selectedColor: const Color(0xFFFF0000),
      showGrid: false,
      gridColor: const Color(0x00000000),
    );
    expect(painter.paintOrder, [2, 4, 1, 3]);
  });

  test('発見演出の画は選択中の画よりさらに前面に描く', () {
    final painter = KanjiStrokePainter(
      glyph: ki,
      selectedStrokeIds: const {1, 3},
      highlightStrokeIds: const {2, 3},
      strokeColor: const Color(0xFF000000),
      selectedColor: const Color(0xFFFF0000),
      showGrid: false,
      gridColor: const Color(0x00000000),
    );
    expect(painter.paintOrder, [4, 1, 2, 3]);
  });
}
