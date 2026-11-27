import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'glyph_repository.dart';
import 'kanji_stroke_view.dart';

/// 漢字1文字のタイル。字は KanjiStrokeView で描く（仕様 6.3）。
///
/// [hidden] が true のときは字を出さず「？」を表示する（図鑑の未発見など）。
class KanjiTile extends ConsumerWidget {
  const KanjiTile({
    super.key,
    required this.character,
    this.onTap,
    this.cleared = false,
    this.hidden = false,
  });

  final String character;
  final VoidCallback? onTap;

  /// クリア済みの印（緑の枠とチェック）を付ける。
  final bool cleared;
  final bool hidden;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    const green = Color(0xFF2EAD4B);
    Widget child;
    if (hidden) {
      child = Center(
        child: Text('？', style: TextStyle(fontSize: 28, color: scheme.outline)),
      );
    } else {
      child = switch (ref.watch(glyphProvider(character))) {
        AsyncData(:final value) => KanjiStrokeView(glyph: value),
        AsyncError() => const Icon(Icons.error_outline),
        _ => const SizedBox.shrink(),
      };
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: cleared
            ? const BorderSide(color: green, width: 3)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Padding(padding: const EdgeInsets.all(10), child: child),
            if (cleared)
              const Positioned(
                right: 4,
                top: 4,
                child: Icon(Icons.check_circle, color: green, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
