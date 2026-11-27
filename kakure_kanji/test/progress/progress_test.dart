import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kakure_kanji/features/progress/progress_provider.dart';
import 'package:kakure_kanji/features/progress/progress_store.dart';
import 'package:kakure_kanji/features/progress/progress_store_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('markCleared: 初回は true、2回目以降は false で回数が増える', () async {
    final store = MemoryProgressStore();
    final container = ProviderContainer(overrides: [
      progressStoreProvider.overrideWith((ref) async => store),
    ]);
    addTearDown(container.dispose);
    await container.read(progressProvider.future);

    final n = container.read(progressProvider.notifier);
    expect(await n.markCleared('木', now: DateTime(2026, 11, 27)), isTrue);
    expect(await n.markCleared('木'), isFalse);
    final r = container.read(progressProvider).value!['木']!;
    expect(r.clearCount, 2);
    expect(r.firstClearedAt, DateTime(2026, 11, 27));
    expect((await store.loadAll()).single.clearCount, 2);
  });

  test('Web 用の保存先: 保存して読み直せる', () async {
    SharedPreferences.setMockInitialValues({});
    final store = WebProgressStore(await SharedPreferences.getInstance());
    await store.save(ClearRecord(
        kanji: '森', firstClearedAt: DateTime(2026, 1, 2), clearCount: 1));
    await store.save(ClearRecord(
        kanji: '森', firstClearedAt: DateTime(2026, 1, 2), clearCount: 3));
    await store.save(ClearRecord(
        kanji: '林', firstClearedAt: DateTime(2026, 1, 3), clearCount: 1));

    final again = WebProgressStore(await SharedPreferences.getInstance());
    final all = {for (final r in await again.loadAll()) r.kanji: r};
    expect(all.keys, unorderedEquals(['森', '林']));
    expect(all['森']!.clearCount, 3);
    expect(all['森']!.firstClearedAt, DateTime(2026, 1, 2));
  });
}
