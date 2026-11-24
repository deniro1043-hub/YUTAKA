import 'dart:ui';

/// AnimCJK の座標系（viewBox 0 0 1024 1024、y は下向き）。
const double kGlyphSize = 1024;

/// 1画分の字形データ。
class GlyphStroke {
  GlyphStroke({
    required this.id,
    required this.outline,
    required this.median,
    required this.medianPoints,
  });

  /// 画番号（1始まり、筆順どおり）。仕様書の strokeIds と同じ番号体系。
  final int id;

  /// 見た目用の塗りつぶし輪郭（AnimCJK の `z{code}d{n}`）。
  final Path outline;

  /// 画の中心線（AnimCJK のアニメーション用パス）。
  final Path median;

  /// 中心線を一定間隔でサンプリングした点列。タップ判定に使う。
  final List<Offset> medianPoints;
}

/// 1文字分の字形データ。
class KanjiGlyph {
  KanjiGlyph({required this.character, required this.strokes});

  final String character;
  final List<GlyphStroke> strokes;

  int get codePoint => character.runes.first;
  int get strokeCount => strokes.length;

  GlyphStroke strokeById(int id) => strokes.firstWhere((s) => s.id == id);
}
