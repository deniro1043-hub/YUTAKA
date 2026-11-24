import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'kanji_glyph.dart';
import 'stroke_hit_tester.dart';

/// 漢字を AnimCJK の画データから1画ずつ描画するウィジェット。
///
/// 仕様書 6.3: ゲーム内の漢字は Text ではなく必ずこのウィジェットで描く。
/// 仕様書 6.4: 未選択の画を先に、選択中の画を最後（最前面）に描く。
class KanjiStrokeView extends StatelessWidget {
  const KanjiStrokeView({
    super.key,
    required this.glyph,
    this.selectedStrokeIds = const {},
    this.onStrokeTap,
    this.strokeColor = const Color(0xFF3A3A3A),
    this.selectedColor = const Color(0xFFFF8A00),
    this.showGrid = false,
    this.gridColor = const Color(0x33888888),
  });

  final KanjiGlyph glyph;
  final Set<int> selectedStrokeIds;

  /// null のときはタップに反応しない（一覧表示などに使う）。
  final ValueChanged<int>? onStrokeTap;
  final Color strokeColor;
  final Color selectedColor;
  final bool showGrid;
  final Color gridColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          final paint = CustomPaint(
            size: size,
            painter: KanjiStrokePainter(
              glyph: glyph,
              selectedStrokeIds: selectedStrokeIds,
              strokeColor: strokeColor,
              selectedColor: selectedColor,
              showGrid: showGrid,
              gridColor: gridColor,
            ),
          );
          final onTap = onStrokeTap;
          if (onTap == null) return paint;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: (details) {
              final point = toGlyphSpace(details.localPosition, size);
              final id = hitTestStroke(glyph, point);
              if (id != null) onTap(id);
            },
            child: paint,
          );
        },
      ),
    );
  }
}

/// ウィジェット座標を字形座標（0〜1024）に変換する。
Offset toGlyphSpace(Offset local, Size size) {
  final scale = math.min(size.width, size.height) / kGlyphSize;
  final origin = Offset(
    (size.width - kGlyphSize * scale) / 2,
    (size.height - kGlyphSize * scale) / 2,
  );
  return (local - origin) / scale;
}

class KanjiStrokePainter extends CustomPainter {
  KanjiStrokePainter({
    required this.glyph,
    required this.selectedStrokeIds,
    required this.strokeColor,
    required this.selectedColor,
    required this.showGrid,
    required this.gridColor,
  });

  final KanjiGlyph glyph;
  final Set<int> selectedStrokeIds;
  final Color strokeColor;
  final Color selectedColor;
  final bool showGrid;
  final Color gridColor;

  /// 描画順（未選択 → 選択）。テストで仕様 6.4 を確認するため公開している。
  List<int> get paintOrder => [
        for (final s in glyph.strokes)
          if (!selectedStrokeIds.contains(s.id)) s.id,
        for (final s in glyph.strokes)
          if (selectedStrokeIds.contains(s.id)) s.id,
      ];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width, size.height) / kGlyphSize;
    canvas.save();
    canvas.translate(
      (size.width - kGlyphSize * scale) / 2,
      (size.height - kGlyphSize * scale) / 2,
    );
    canvas.scale(scale);

    if (showGrid) _paintGrid(canvas, scale);

    final normal = Paint()..color = strokeColor;
    final selected = Paint()..color = selectedColor;
    for (final id in paintOrder) {
      final paint = selectedStrokeIds.contains(id) ? selected : normal;
      canvas.drawPath(glyph.strokeById(id).outline, paint);
    }
    canvas.restore();
  }

  void _paintGrid(Canvas canvas, double scale) {
    final paint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 / scale;
    const s = kGlyphSize;
    canvas.drawRect(const Rect.fromLTWH(0, 0, s, s), paint);
    canvas.drawLine(const Offset(s / 2, 0), const Offset(s / 2, s), paint);
    canvas.drawLine(const Offset(0, s / 2), const Offset(s, s / 2), paint);
  }

  @override
  bool shouldRepaint(KanjiStrokePainter old) =>
      old.glyph != glyph ||
      !_setEquals(old.selectedStrokeIds, selectedStrokeIds) ||
      old.strokeColor != strokeColor ||
      old.selectedColor != selectedColor ||
      old.showGrid != showGrid ||
      old.gridColor != gridColor;
}

bool _setEquals(Set<int> a, Set<int> b) =>
    a.length == b.length && a.containsAll(b);
