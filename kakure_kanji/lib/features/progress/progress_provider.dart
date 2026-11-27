import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'progress_store.dart';
// Web では Isar を使わない（Isar 3 が Web のビルドに対応していないため）。
import 'progress_store_isar.dart'
    if (dart.library.js_interop) 'progress_store_web.dart' as platform;

/// 進捗の保存先。テストでは MemoryProgressStore に差し替える。
final progressStoreProvider = FutureProvider<ProgressStore>(
  (ref) => platform.openProgressStore(),
);

/// クリア記録（漢字 → 記録）。
class ProgressNotifier extends AsyncNotifier<Map<String, ClearRecord>> {
  @override
  Future<Map<String, ClearRecord>> build() async {
    final store = await ref.watch(progressStoreProvider.future);
    final records = await store.loadAll();
    return {for (final r in records) r.kanji: r};
  }

  /// [kanji] をクリアしたことを記録する。初回なら true を返す。
  Future<bool> markCleared(String kanji, {DateTime? now}) async {
    final store = await ref.read(progressStoreProvider.future);
    final current = state.value ?? await future;
    final existing = current[kanji];
    final record = existing?.clearedAgain() ??
        ClearRecord(
          kanji: kanji,
          firstClearedAt: now ?? DateTime.now(),
          clearCount: 1,
        );
    await store.save(record);
    state = AsyncData({...current, kanji: record});
    return existing == null;
  }
}

final progressProvider =
    AsyncNotifierProvider<ProgressNotifier, Map<String, ClearRecord>>(
  ProgressNotifier.new,
);
