import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

import 'kanji_glyph.dart';

/// AnimCJK の SVG（svgsJa/{codepoint}.svg）を [KanjiGlyph] に変換する。
///
/// SVG の構造:
/// - `<path id="z{code}d{n}" d="..."/>` … n画目の輪郭
/// - `<path clip-path="url(#z{code}c{n})" d="..."/>` … n画目の中心線
class AnimCjkParseException implements Exception {
  AnimCjkParseException(this.message);
  final String message;
  @override
  String toString() => 'AnimCjkParseException: $message';
}

const double _sampleStep = 8;

KanjiGlyph parseAnimCjkSvg(String svg) {
  final doc = XmlDocument.parse(svg);
  final root = doc.rootElement;
  final rootId = root.getAttribute('id') ?? '';
  final codeMatch = RegExp(r'^z(\d+)$').firstMatch(rootId);
  if (codeMatch == null) {
    throw AnimCjkParseException('svg の id が不正です: "$rootId"');
  }
  final code = codeMatch.group(1)!;
  final outlineRe = RegExp('^z${code}d(\\d+)\$');
  final clipRe = RegExp('^url\\(#z${code}c(\\d+)\\)\$');

  final outlines = <int, Path>{};
  final medians = <int, Path>{};
  for (final path in root.findAllElements('path')) {
    final d = path.getAttribute('d');
    if (d == null) continue;
    final id = path.getAttribute('id');
    final clip = path.getAttribute('clip-path');
    final o = id == null ? null : outlineRe.firstMatch(id);
    final m = clip == null ? null : clipRe.firstMatch(clip);
    if (o != null) {
      outlines[int.parse(o.group(1)!)] = parseSvgPathData(d);
    } else if (m != null) {
      medians[int.parse(m.group(1)!)] = parseSvgPathData(d);
    }
  }

  if (outlines.isEmpty) {
    throw AnimCjkParseException('画が見つかりません (z$code)');
  }
  final ids = outlines.keys.toList()..sort();
  for (var i = 0; i < ids.length; i++) {
    if (ids[i] != i + 1) {
      throw AnimCjkParseException('画番号が連番ではありません: $ids');
    }
  }

  final strokes = [
    for (final id in ids)
      GlyphStroke(
        id: id,
        outline: outlines[id]!,
        median: medians[id] ?? outlines[id]!,
        medianPoints: _samplePath(medians[id] ?? outlines[id]!),
      ),
  ];
  return KanjiGlyph(
    character: String.fromCharCode(int.parse(code)),
    strokes: strokes,
  );
}

List<Offset> _samplePath(Path path) {
  final points = <Offset>[];
  for (final metric in path.computeMetrics()) {
    for (double t = 0; t < metric.length; t += _sampleStep) {
      points.add(metric.getTangentForOffset(t)!.position);
    }
    points.add(metric.getTangentForOffset(metric.length)!.position);
  }
  return points;
}
