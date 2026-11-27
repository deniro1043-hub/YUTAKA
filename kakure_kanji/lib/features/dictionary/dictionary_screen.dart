import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../glyph/kanji_tile.dart';
import '../judge/puzzle_repository.dart';
import '../progress/progress_provider.dart';
import '../stage/grade_select_screen.dart';

/// 図鑑（仕様 24.3: 学年別表示・発見済み管理）。
///
/// クリアした漢字が載る（2026-11-27 決定）。まだの字は「？」で表示する。
class DictionaryScreen extends ConsumerWidget {
  const DictionaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(puzzleCatalogProvider).value;
    final cleared = ref.watch(progressProvider).value ?? const {};
    final grades = kGradeKanjiCount.keys.toList();

    return DefaultTabController(
      length: grades.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ずかん'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [for (final g in grades) Tab(text: '$g ねん')],
          ),
        ),
        body: catalog == null
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  for (final g in grades)
                    _GradePage(
                      kanji: catalog.grade(g)?.kanji ?? const [],
                      total: kGradeKanjiCount[g]!,
                      cleared: cleared.keys.toSet(),
                    ),
                ],
              ),
      ),
    );
  }
}

class _GradePage extends StatelessWidget {
  const _GradePage({
    required this.kanji,
    required this.total,
    required this.cleared,
  });

  final List<String> kanji;
  final int total;
  final Set<String> cleared;

  @override
  Widget build(BuildContext context) {
    final count = kanji.where(cleared.contains).length;
    if (kanji.isEmpty) {
      return const Center(child: Text('じゅんびちゅう'));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            'あつめた かず: $count / $total',
            key: const ValueKey('dictionary-count'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: GridView.extent(
            maxCrossAxisExtent: 72,
            padding: const EdgeInsets.all(16),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (final k in kanji)
                KanjiTile(
                  key: ValueKey('dict-${k.runes.first}'),
                  character: k,
                  hidden: !cleared.contains(k),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
