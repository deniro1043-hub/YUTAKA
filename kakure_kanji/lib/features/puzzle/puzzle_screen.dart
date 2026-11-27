import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../glyph/glyph_repository.dart';
import '../glyph/kanji_glyph.dart';
import '../glyph/kanji_stroke_view.dart';
import '../judge/part_judge.dart';
import '../judge/puzzle_data.dart';
import '../judge/puzzle_repository.dart';
import '../progress/progress_provider.dart';
import 'found_parts.dart';
import 'stroke_selection.dart';

/// 発見演出の長さ。
const kDiscoveryDuration = Duration(milliseconds: 1400);

/// 問題画面（画の選択 → 部品判定 → 発見演出 → 発見リスト → 全部見つけたらクリア）。
class PuzzleScreen extends ConsumerWidget {
  const PuzzleScreen({super.key, required this.character});

  final String character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glyph = ref.watch(glyphProvider(character));
    final catalog = ref.watch(puzzleCatalogProvider);

    Widget body;
    if (glyph.hasError || catalog.hasError) {
      body = Center(
        child: Text('データを読み込めませんでした\n${glyph.error ?? catalog.error}'),
      );
    } else if (!glyph.hasValue || !catalog.hasValue) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      final puzzle = catalog.value!.puzzleFor(character);
      body = puzzle == null
          ? const Center(child: Text('この字の問題データはまだありません'))
          : _PuzzleBody(
              glyph: glyph.value!,
              puzzle: puzzle,
              judge: catalog.value!.judgeFor(puzzle),
              nextKanji: catalog.value!.nextStage(puzzle),
            );
    }
    return Scaffold(appBar: AppBar(title: const Text('もんだい')), body: body);
  }
}

class _PuzzleBody extends ConsumerStatefulWidget {
  const _PuzzleBody({
    required this.glyph,
    required this.puzzle,
    required this.judge,
    required this.nextKanji,
  });

  final KanjiGlyph glyph;
  final PuzzleData puzzle;
  final PartJudge judge;

  /// 同じ学年の次のステージ（なければ null）。
  final String? nextKanji;

  @override
  ConsumerState<_PuzzleBody> createState() => _PuzzleBodyState();
}

class _PuzzleBodyState extends ConsumerState<_PuzzleBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _discovery = AnimationController(
    vsync: this,
    duration: kDiscoveryDuration,
  );
  PartFound? _lastFound;
  String? _message;
  Timer? _messageTimer;

  String get _character => widget.puzzle.kanji;

  @override
  void dispose() {
    _discovery.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  void _showMessage(String message) {
    _messageTimer?.cancel();
    setState(() => _message = message);
    _messageTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _message = null);
    });
  }

  /// 部品を全部見つけたらクリア（2026-11-27 決定）。記録して結果を表示する。
  Future<void> _onCleared() async {
    final firstTime =
        await ref.read(progressProvider.notifier).markCleared(_character);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ResultDialog(
        character: _character,
        firstTime: firstTime,
        nextKanji: widget.nextKanji,
        grade: widget.puzzle.grade,
      ),
    );
  }

  void _check() {
    final selection = ref.read(strokeSelectionProvider(_character).notifier);
    final found = ref.read(foundPartsProvider(_character));
    final result = widget.judge.judge(
      ref.read(strokeSelectionProvider(_character)),
      found: found.toSet(),
    );
    switch (result) {
      case PartFound():
        ref.read(foundPartsProvider(_character).notifier).add(result.part.name);
        selection.clear();
        setState(() {
          _lastFound = result;
          _message = null;
        });
        final cleared = found.length + 1 >= widget.judge.totalParts;
        _discovery.forward(from: 0).whenComplete(() {
          if (cleared && mounted) _onCleared();
        });
      case PartAlreadyFound():
        selection.clear();
        _showMessage('それは もう みつけたよ');
      case NoMatch():
        _showMessage('ちがうみたい。もういちど えらんでみよう');
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(strokeSelectionProvider(_character));
    final found = ref.watch(foundPartsProvider(_character));
    final total = widget.judge.totalParts;
    final ids = selected.toList()..sort();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'みつけた かず: ${found.length} / $total',
              key: const ValueKey('progress-label'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: AnimatedBuilder(
                    animation: _discovery,
                    builder: (context, _) {
                      final active = _discovery.isAnimating;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          KanjiStrokeView(
                            key: const ValueKey('puzzle-kanji'),
                            glyph: widget.glyph,
                            selectedStrokeIds: selected,
                            highlightStrokeIds: active && _lastFound != null
                                ? _lastFound!.strokeIds.toSet()
                                : const {},
                            onStrokeTap: ref
                                .read(strokeSelectionProvider(_character)
                                    .notifier)
                                .toggle,
                            showGrid: true,
                          ),
                          if (active && _lastFound != null)
                            IgnorePointer(
                              child: _DiscoveryBadge(
                                part: _lastFound!.part.name,
                                progress: _discovery.value,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 24,
              child: Text(
                _message ??
                    (ids.isEmpty
                        ? '画をタップして えらんでね（${widget.glyph.strokeCount}画）'
                        : 'えらんだ画: ${ids.join(', ')}'),
                key: const ValueKey('status-label'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: ids.isEmpty
                      ? null
                      : ref
                          .read(strokeSelectionProvider(_character).notifier)
                          .clear,
                  child: const Text('えらびなおす'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  key: const ValueKey('check-button'),
                  onPressed: ids.isEmpty ? null : _check,
                  child: const Text('けってい'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _FoundList(found: found, total: total),
          ],
        ),
      ),
    );
  }
}

/// 発見したときに、見つけた部品漢字をポップアップ表示する。
class _DiscoveryBadge extends ConsumerWidget {
  const _DiscoveryBadge({required this.part, required this.progress});

  final String part;

  /// 0〜1 のアニメーション進行度。
  final double progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glyph = ref.watch(glyphProvider(part)).value;
    final scale = Curves.elasticOut.transform((progress * 2).clamp(0.0, 1.0));
    final opacity = progress < 0.8 ? 1.0 : (1 - progress) / 0.2;
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Transform.scale(
        scale: 0.3 + 0.7 * scale,
        child: Container(
          key: const ValueKey('discovery-badge'),
          width: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF2EAD4B), width: 4),
            boxShadow: const [
              BoxShadow(blurRadius: 16, color: Color(0x33000000)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'みつけた！',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2EAD4B),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 110,
                child: glyph == null
                    ? const SizedBox(height: 110)
                    : KanjiStrokeView(
                        glyph: glyph,
                        strokeColor: const Color(0xFF2EAD4B),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 発見リスト（見つけた部品漢字と、残りの数の「？」）。
class _FoundList extends ConsumerWidget {
  const _FoundList({required this.found, required this.total});

  final List<String> found;
  final int total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        for (final part in found)
          _slot(
            scheme,
            key: ValueKey('found-${part.runes.first}'),
            child: switch (ref.watch(glyphProvider(part))) {
              AsyncData(:final value) => KanjiStrokeView(glyph: value),
              _ => const SizedBox.shrink(),
            },
          ),
        for (var i = found.length; i < total; i++)
          _slot(
            scheme,
            child: Center(
              child: Text('？',
                  style: TextStyle(fontSize: 22, color: scheme.outline)),
            ),
          ),
      ],
    );
  }

  Widget _slot(ColorScheme scheme, {Key? key, required Widget child}) =>
      Container(
        key: key,
        width: 52,
        height: 52,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      );
}

/// クリア時の結果表示（仕様 24 / 25: ResultDialog）。
class ResultDialog extends ConsumerWidget {
  const ResultDialog({
    super.key,
    required this.character,
    required this.firstTime,
    required this.nextKanji,
    required this.grade,
  });

  final String character;
  final bool firstTime;
  final String? nextKanji;
  final int grade;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final glyph = ref.watch(glyphProvider(character)).value;
    final next = nextKanji;
    // AlertDialog は中身の幅を測ろうとして字形描画（LayoutBuilder）と相性が悪いため、
    // 大きさを固定した Dialog で作る。
    return Dialog(
      key: const ValueKey('result-dialog'),
      child: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'クリア！',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2EAD4B),
                    ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 120,
                height: 120,
                child: glyph == null
                    ? null
                    : KanjiStrokeView(
                        glyph: glyph,
                        strokeColor: const Color(0xFF2EAD4B),
                      ),
              ),
              const SizedBox(height: 12),
              Text(firstTime ? 'ずかんに とうろく したよ！' : 'もういちど クリアしたよ！'),
              const SizedBox(height: 20),
              if (next != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const ValueKey('next-stage'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/grades/$grade/${next.runes.first}');
                    },
                    child: const Text('つぎの もじ'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/grades/$grade');
                  },
                  child: const Text('ステージに もどる'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
