import 'puzzle_data.dart';

/// 選択ストロークの判定結果。
sealed class JudgeResult {
  const JudgeResult();
}

/// 新しく部品漢字を見つけた。
class PartFound extends JudgeResult {
  const PartFound(this.part, this.strokeIds);
  final PartData part;

  /// 一致したパターン（昇順）。発見演出で光らせる画。
  final List<int> strokeIds;
}

/// 見つけ済みの部品漢字と同じ組み合わせだった（仕様 11.5: 同じ部品は1回だけ）。
class PartAlreadyFound extends JudgeResult {
  const PartAlreadyFound(this.part);
  final PartData part;
}

/// どの部品漢字とも一致しない。
class NoMatch extends JudgeResult {
  const NoMatch();
}

/// 事前登録データだけで部品を判定する（仕様 10.1。実行時の推論はしない）。
class PartJudge {
  /// [stageGrade] 以下の学年の漢字だけを部品として扱う（仕様 11.2）。
  /// [gradeOf] は漢字→配当学年。登録のない漢字（学年外）は対象外。
  /// [stageGrade] が null のときは学年で絞り込まない（おまけステージなど）。
  PartJudge({
    required this.puzzle,
    required Map<String, int> gradeOf,
    int? stageGrade,
  }) : parts = [
          for (final p in puzzle.parts)
            if (stageGrade == null ||
                ((gradeOf[p.name] ?? 99) <= stageGrade))
              p,
        ];

  final PuzzleData puzzle;

  /// このステージで見つけられる部品漢字。
  final List<PartData> parts;

  int get totalParts => parts.length;

  /// [selected] の画の集合がいずれかの部品のパターンと完全に一致するか調べる。
  /// 画の重複利用は認める（仕様 11.4）ので、見つけ済みの画を含んでいてもよい。
  JudgeResult judge(Set<int> selected, {Set<String> found = const {}}) {
    if (selected.isEmpty) return const NoMatch();
    final key = (selected.toList()..sort());
    for (final part in parts) {
      for (final pattern in part.strokePatterns) {
        if (_listEquals(pattern, key)) {
          return found.contains(part.name)
              ? PartAlreadyFound(part)
              : PartFound(part, pattern);
        }
      }
    }
    return const NoMatch();
  }
}

bool _listEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
