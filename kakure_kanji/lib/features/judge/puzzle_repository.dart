import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'part_judge.dart';
import 'puzzle_data.dart';

/// 同梱済みの判定データ（assets/json/grade_N.json）の学年。
/// 学年データを追加したらここにも足す。
const kAvailableGrades = [1];

/// 判定データ一式。
class PuzzleCatalog {
  PuzzleCatalog(this.grades);

  final List<GradeData> grades;

  /// 漢字 → 配当学年（仕様 11.2 の学年制限に使う）。
  late final Map<String, int> gradeOf = {
    for (final g in grades)
      for (final k in g.kanji) k: g.grade,
  };

  PuzzleData? puzzleFor(String kanji) {
    for (final g in grades) {
      for (final p in g.puzzles) {
        if (p.kanji == kanji) return p;
      }
    }
    return null;
  }

  /// 問題漢字の学年ステージ用の判定器。
  PartJudge judgeFor(PuzzleData puzzle) => PartJudge(
        puzzle: puzzle,
        gradeOf: gradeOf,
        stageGrade: puzzle.grade == 0 ? null : puzzle.grade,
      );
}

Future<PuzzleCatalog> loadPuzzleCatalog(AssetBundle bundle) async => PuzzleCatalog([
      for (final g in kAvailableGrades)
        GradeData.fromJsonString(
          await bundle.loadString('assets/json/grade_$g.json'),
        ),
    ]);

final puzzleCatalogProvider = FutureProvider<PuzzleCatalog>(
  (ref) => loadPuzzleCatalog(rootBundle),
);
