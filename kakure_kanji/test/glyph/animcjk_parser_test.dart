import 'package:flutter_test/flutter_test.dart';
import 'package:kakure_kanji/features/glyph/animcjk_parser.dart';
import 'package:kakure_kanji/features/home/home_screen.dart';

import 'test_glyphs.dart';

void main() {
  const expectedStrokeCounts = {
    '一': 1, '二': 2, '三': 3, '十': 2, '土': 3, '口': 3, '日': 4, '月': 4, //
    '目': 5, '山': 3, '出': 5, '木': 4, '林': 8, '森': 12, '水': 4, '小': 3,
  };

  test('同梱サンプルがすべて読み込め、画数が正しい', () {
    expect(kSampleKanji.toSet(), expectedStrokeCounts.keys.toSet()..remove('小'));
    for (final entry in expectedStrokeCounts.entries) {
      final glyph = loadTestGlyph(entry.key);
      expect(glyph.character, entry.key);
      expect(glyph.strokeCount, entry.value, reason: entry.key);
      expect(glyph.strokes.map((s) => s.id),
          List.generate(entry.value, (i) => i + 1));
      for (final s in glyph.strokes) {
        expect(s.medianPoints, isNotEmpty, reason: '${entry.key} ${s.id}');
      }
    }
  });

  test('不正な SVG は例外になる', () {
    expect(() => parseAnimCjkSvg('<svg id="x"></svg>'),
        throwsA(isA<AnimCjkParseException>()));
    expect(() => parseAnimCjkSvg('<svg id="z26408"></svg>'),
        throwsA(isA<AnimCjkParseException>()));
  });
}
