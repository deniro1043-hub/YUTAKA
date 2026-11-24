import 'dart:math' as math;
import 'dart:ui';

import 'kanji_glyph.dart';

/// 中心線からこの距離（字形座標）以内なら、その画をタップしたとみなす。
/// 細い画でも指で押しやすいよう、見た目の線幅より広めにとる。
const double kStrokeHitTolerance = 72;

/// [point]（字形座標 0〜1024）に最も近い画の番号を返す。該当なしは null。
///
/// 輪郭の内側にある画、または中心線から [tolerance] 以内の画を候補とし、
/// 中心線が最も近い画を選ぶ。画の交点では中心線の近いほうが選ばれる。
int? hitTestStroke(
  KanjiGlyph glyph,
  Offset point, {
  double tolerance = kStrokeHitTolerance,
}) {
  int? best;
  var bestDistance = double.infinity;
  for (final stroke in glyph.strokes) {
    final distance = _distanceToPoints(point, stroke.medianPoints);
    final inside = stroke.outline.contains(point);
    if (!inside && distance > tolerance) continue;
    if (distance < bestDistance) {
      bestDistance = distance;
      best = stroke.id;
    }
  }
  return best;
}

double _distanceToPoints(Offset p, List<Offset> points) {
  if (points.isEmpty) return double.infinity;
  if (points.length == 1) return (p - points.first).distance;
  var min = double.infinity;
  for (var i = 0; i < points.length - 1; i++) {
    min = math.min(min, _distanceToSegment(p, points[i], points[i + 1]));
  }
  return min;
}

double _distanceToSegment(Offset p, Offset a, Offset b) {
  final ab = b - a;
  final lengthSquared = ab.dx * ab.dx + ab.dy * ab.dy;
  if (lengthSquared == 0) return (p - a).distance;
  final ap = p - a;
  final t = ((ap.dx * ab.dx + ap.dy * ab.dy) / lengthSquared).clamp(0.0, 1.0);
  return (p - (a + ab * t)).distance;
}
