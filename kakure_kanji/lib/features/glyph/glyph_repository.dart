import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'animcjk_parser.dart';
import 'kanji_glyph.dart';

/// AnimCJK の SVG をアセットから読み込み、解析結果をキャッシュする。
class GlyphRepository {
  GlyphRepository(this._bundle);

  final AssetBundle _bundle;
  final Map<String, Future<KanjiGlyph>> _cache = {};

  static String assetPath(String character) =>
      'assets/animcjk/${character.runes.first}.svg';

  Future<KanjiGlyph> load(String character) {
    return _cache.putIfAbsent(character, () async {
      final svg = await _bundle.loadString(assetPath(character));
      return parseAnimCjkSvg(svg);
    });
  }
}

final glyphRepositoryProvider = Provider<GlyphRepository>(
  (ref) => GlyphRepository(rootBundle),
);

final glyphProvider = FutureProvider.family<KanjiGlyph, String>(
  (ref, character) => ref.watch(glyphRepositoryProvider).load(character),
);
