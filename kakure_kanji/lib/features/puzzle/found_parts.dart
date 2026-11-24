import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 問題漢字ごとの、見つけた部品漢字（見つけた順）。
///
/// 今はメモリ上だけで持つ。図鑑への保存（Isar）は Phase3 で追加する。
class FoundPartsNotifier extends Notifier<List<String>> {
  FoundPartsNotifier(this.character);

  final String character;

  @override
  List<String> build() => const [];

  void add(String part) {
    if (state.contains(part)) return;
    state = [...state, part];
  }

  void reset() => state = const [];
}

final foundPartsProvider =
    NotifierProvider.family<FoundPartsNotifier, List<String>, String>(
  FoundPartsNotifier.new,
);
