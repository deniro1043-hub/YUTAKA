/// 1文字分のクリア記録（仕様 26.5 ProgressData）。
class ClearRecord {
  const ClearRecord({
    required this.kanji,
    required this.firstClearedAt,
    required this.clearCount,
  });

  final String kanji;
  final DateTime firstClearedAt;

  /// クリアした回数（初回を含む）。コイン（仕様 19章）の計算に使う。
  final int clearCount;

  ClearRecord clearedAgain() => ClearRecord(
        kanji: kanji,
        firstClearedAt: firstClearedAt,
        clearCount: clearCount + 1,
      );

  Map<String, dynamic> toJson() => {
        'kanji': kanji,
        'firstClearedAt': firstClearedAt.toIso8601String(),
        'clearCount': clearCount,
      };

  factory ClearRecord.fromJson(Map<String, dynamic> json) => ClearRecord(
        kanji: json['kanji'] as String,
        firstClearedAt: DateTime.parse(json['firstClearedAt'] as String),
        clearCount: json['clearCount'] as int,
      );
}

/// 進捗の保存先。
///
/// - iOS / Windows（正式版）: Isar（仕様 3.3）… `progress_store_isar.dart`
/// - Web（スマホ確認用）: ブラウザの保存領域 … `progress_store_web.dart`
///   （Isar 3 は Web 版のビルドに対応していないため）
abstract class ProgressStore {
  Future<List<ClearRecord>> loadAll();
  Future<void> save(ClearRecord record);
}

/// メモリ上だけに保存する（テスト用）。
class MemoryProgressStore implements ProgressStore {
  MemoryProgressStore([Iterable<ClearRecord> initial = const []])
      : _records = {for (final r in initial) r.kanji: r};

  final Map<String, ClearRecord> _records;

  @override
  Future<List<ClearRecord>> loadAll() async => _records.values.toList();

  @override
  Future<void> save(ClearRecord record) async => _records[record.kanji] = record;
}
