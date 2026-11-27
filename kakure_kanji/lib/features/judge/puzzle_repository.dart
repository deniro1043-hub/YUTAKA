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

  GradeData? grade(int grade) {
    for (final g in grades) {
      if (g.grade == grade) return g;
    }
    return null;
  }

  /// 学年のステージ（1ステージ = 1文字。2026-11-27 決定）。
  /// 配当漢字の並び順で、問題データのある字だけを返す。
  List<PuzzleData> stagesFor(int gradeNumber) {
    final g = grade(gradeNumber);
    if (g == null) return const [];
    final byKanji = {for (final p in g.puzzles) p.kanji: p};
    return [
      for (final k in g.kanji)
        if (byKanji[k] != null) byKanji[k]!,
    ];
  }

  /// 同じ学年で [puzzle] の次のステージの字。最後なら null。
  String? nextStage(PuzzleData puzzle) {
    final stages = stagesFor(puzzle.grade);
    final i = stages.indexWhere((p) => p.kanji == puzzle.kanji);
    return i >= 0 && i + 1 < stages.length ? stages[i + 1].kanji : null;
  }

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
