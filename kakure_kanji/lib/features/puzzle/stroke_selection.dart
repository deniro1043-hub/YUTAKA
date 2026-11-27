import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 問題漢字ごとの選択中ストローク（画番号の集合）。
class StrokeSelectionNotifier extends Notifier<Set<int>> {
  StrokeSelectionNotifier(this.character);

  final String character;

  @override
  Set<int> build() => const {};

  /// 未選択なら選択し、選択済みなら解除する。
  void toggle(int strokeId) {
    state = state.contains(strokeId)
        ? ({...state}..remove(strokeId))
        : {...state, strokeId};
  }

  void clear() => state = const {};
}

final strokeSelectionProvider =
    NotifierProvider.autoDispose.family<StrokeSelectionNotifier, Set<int>, String>(
  StrokeSelectionNotifier.new,
);
