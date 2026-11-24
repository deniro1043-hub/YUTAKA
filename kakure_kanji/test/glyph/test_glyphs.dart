import 'dart:io';

import 'package:kakure_kanji/features/glyph/animcjk_parser.dart';
import 'package:kakure_kanji/features/glyph/kanji_glyph.dart';

/// テスト用に同梱アセットから字形を読み込む。
KanjiGlyph loadTestGlyph(String character) => parseAnimCjkSvg(
      File('assets/animcjk/${character.runes.first}.svg').readAsStringSync(),
    );
