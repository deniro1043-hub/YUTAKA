import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'progress_store.dart';

/// Web（スマホ確認用）の保存先。ブラウザの保存領域に JSON で保存する。
/// Isar 3 は Web 版のビルドに対応していないため、Web だけこちらを使う。
class WebProgressStore implements ProgressStore {
  WebProgressStore(this._prefs);

  static const _key = 'kakure_kanji.clear_records';
  final SharedPreferences _prefs;

  Map<String, ClearRecord> _read() {
    final raw = _prefs.getString(_key);
    if (raw == null) return {};
    final list = jsonDecode(raw) as List;
    return {
      for (final e in list)
        (e as Map<String, dynamic>)['kanji'] as String: ClearRecord.fromJson(e),
    };
  }

  @override
  Future<List<ClearRecord>> loadAll() async => _read().values.toList();

  @override
  Future<void> save(ClearRecord record) async {
    final all = _read()..[record.kanji] = record;
    await _prefs.setString(
      _key,
      jsonEncode([for (final r in all.values) r.toJson()]),
    );
  }
}

Future<ProgressStore> openProgressStore() async =>
    WebProgressStore(await SharedPreferences.getInstance());
