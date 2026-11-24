import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../glyph/glyph_repository.dart';
import '../glyph/kanji_stroke_view.dart';
import 'stroke_selection.dart';

/// 問題画面（Phase1: 描画と画の選択のみ。判定は Phase2 で追加する）。
class PuzzleScreen extends ConsumerWidget {
  const PuzzleScreen({super.key, required this.character});

  final String character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glyph = ref.watch(glyphProvider(character));
    final selected = ref.watch(strokeSelectionProvider(character));
    final selection = ref.read(strokeSelectionProvider(character).notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('もんだい')),
      body: glyph.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('字形を読み込めませんでした\n$e')),
        data: (glyph) {
          final ids = selected.toList()..sort();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: KanjiStrokeView(
                          key: const ValueKey('puzzle-kanji'),
                          glyph: glyph,
                          selectedStrokeIds: selected,
                          onStrokeTap: selection.toggle,
                          showGrid: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ids.isEmpty
                        ? '画をタップして えらんでね（${glyph.strokeCount}画）'
                        : 'えらんだ画: ${ids.join(', ')}',
                    key: const ValueKey('selection-label'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: ids.isEmpty ? null : selection.clear,
                    child: const Text('えらびなおす'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
