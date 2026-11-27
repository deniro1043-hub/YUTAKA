import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../glyph/kanji_tile.dart';
import '../judge/puzzle_repository.dart';
import '../progress/progress_provider.dart';

/// ステージ選択画面（仕様 24 / 25: StageSelectScreen）。1ステージ = 1文字。
class StageSelectScreen extends ConsumerWidget {
  const StageSelectScreen({super.key, required this.grade});

  final int grade;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(puzzleCatalogProvider).value;
    final cleared = ref.watch(progressProvider).value ?? const {};
    final stages = catalog?.stagesFor(grade) ?? const [];
    final clearedCount = stages.where((p) => cleared.containsKey(p.kanji)).length;

    return Scaffold(
      appBar: AppBar(title: Text('$grade ねんせい')),
      body: catalog == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    'クリア $clearedCount / ${stages.length}',
                    key: const ValueKey('stage-progress'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: GridView.extent(
                    maxCrossAxisExtent: 110,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      for (final p in stages)
                        KanjiTile(
                          key: ValueKey('stage-${p.kanji.runes.first}'),
                          character: p.kanji,
                          cleared: cleared.containsKey(p.kanji),
                          onTap: () => context
                              .push('/grades/$grade/${p.kanji.runes.first}'),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
