import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'progress_store.dart';

part 'progress_store_isar.g.dart';

/// Isar に保存するクリア記録。id は漢字のコードポイント（1文字に1件）。
@collection
class ClearRecordEntity {
  ClearRecordEntity();

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String kanji;

  late DateTime firstClearedAt;
  late int clearCount;
}

/// iOS / Windows 用の保存先（仕様 3.3: Isar）。
class IsarProgressStore implements ProgressStore {
  IsarProgressStore(this._isar);

  final Isar _isar;

  static Future<IsarProgressStore> open() async {
    final dir = await getApplicationSupportDirectory();
    final isar = Isar.getInstance('kakure_kanji') ??
        await Isar.open(
          [ClearRecordEntitySchema],
          directory: dir.path,
          name: 'kakure_kanji',
        );
    return IsarProgressStore(isar);
  }

  @override
  Future<List<ClearRecord>> loadAll() async {
    final all = await _isar.clearRecordEntitys.where().findAll();
    return [
      for (final e in all)
        ClearRecord(
          kanji: e.kanji,
          firstClearedAt: e.firstClearedAt,
          clearCount: e.clearCount,
        ),
    ];
  }

  @override
  Future<void> save(ClearRecord record) async {
    final entity = ClearRecordEntity()
      ..id = record.kanji.runes.first
      ..kanji = record.kanji
      ..firstClearedAt = record.firstClearedAt
      ..clearCount = record.clearCount;
    await _isar.writeTxn(() => _isar.clearRecordEntitys.put(entity));
  }
}

Future<ProgressStore> openProgressStore() => IsarProgressStore.open();
