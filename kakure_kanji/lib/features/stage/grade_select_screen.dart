import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../judge/puzzle_repository.dart';
import '../progress/progress_provider.dart';

/// 学年ごとの配当漢字の数（仕様 5.1 / 20.5）。
const kGradeKanjiCount = {1: 80, 2: 160, 3: 200, 4: 202, 5: 193, 6: 191};

/// 学年選択画面（仕様 24 / 25: GradeSelectScreen）。
class GradeSelectScreen extends ConsumerWidget {
  const GradeSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(puzzleCatalogProvider).value;
    final cleared = ref.watch(progressProvider).value ?? const {};

    return Scaffold(
      appBar: AppBar(title: const Text('がくねんを えらぶ')),
      body: catalog == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final entry in kGradeKanjiCount.entries)
                  _GradeCard(
                    grade: entry.key,
                    total: entry.value,
                    playable: catalog.stagesFor(entry.key).length,
                    cleared: (catalog.grade(entry.key)?.kanji ?? const [])
                        .where(cleared.containsKey)
                        .length,
                  ),
              ],
            ),
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({
    required this.grade,
    required this.total,
    required this.playable,
    required this.cleared,
  });

  final int grade;
  final int total;
  final int playable;
  final int cleared;

  @override
  Widget build(BuildContext context) {
    final ready = playable > 0;
    return Card(
      key: ValueKey('grade-$grade'),
      child: ListTile(
        enabled: ready,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          '$grade ねんせい',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          ready
              ? 'クリア $cleared / $total（いま あそべる字: $playable）'
              : 'じゅんびちゅう',
        ),
        trailing: ready ? const Icon(Icons.chevron_right) : null,
        onTap: ready ? () => context.push('/grades/$grade') : null,
      ),
    );
  }
}
