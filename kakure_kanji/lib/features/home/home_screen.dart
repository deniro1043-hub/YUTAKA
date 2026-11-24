import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../glyph/glyph_repository.dart';
import '../glyph/kanji_stroke_view.dart';

/// Phase1 で同梱しているサンプル字形。本編の収録データは Phase3 で差し替える。
const kSampleKanji = [
  '一', '二', '三', '十', '土', '口', '日', '月', //
  '目', '山', '出', '木', '林', '森', '水',
];

/// ホーム画面（Phase1: 字形の確認用に、問題漢字の一覧だけを置く）。
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('かくれ漢字'),
        actions: [
          IconButton(
            tooltip: 'ライセンス',
            icon: const Icon(Icons.info_outline),
            onPressed: () => showLicensePage(
              context: context,
              applicationName: 'かくれ漢字',
            ),
          ),
        ],
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 120,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          for (final c in kSampleKanji) _KanjiTile(character: c),
        ],
      ),
    );
  }
}

class _KanjiTile extends ConsumerWidget {
  const _KanjiTile({required this.character});

  final String character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glyph = ref.watch(glyphProvider(character));
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: ValueKey('tile-${character.runes.first}'),
        onTap: () => context.push('/puzzle/${character.runes.first}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: glyph.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const Icon(Icons.error_outline),
            data: (g) => KanjiStrokeView(glyph: g),
          ),
        ),
      ),
    );
  }
}
