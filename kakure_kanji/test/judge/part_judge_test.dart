import 'package:flutter_test/flutter_test.dart';
import 'package:kakure_kanji/features/judge/part_judge.dart';
import 'package:kakure_kanji/features/judge/puzzle_data.dart';

PuzzleData _mori() => PuzzleData(
      kanji: '森',
      grade: 1,
      strokeCount: 12,
      parts: [
        PartData(name: '木', strokePatterns: [
          [1, 2, 3, 4],
          [5, 6, 7, 8],
          [9, 10, 11, 12],
        ]),
        PartData(name: '林', strokePatterns: [
          [5, 6, 7, 8, 9, 10, 11, 12],
        ]),
        PartData(name: '森', strokePatterns: [
          [for (var i = 1; i <= 12; i++) i],
        ]),
      ],
    );

void main() {
  final judge = PartJudge(
    puzzle: _mori(),
    gradeOf: const {'木': 1, '林': 1, '森': 1},
    stageGrade: 1,
  );

  test('パターンと一致すれば発見（選んだ順番は問わない）', () {
    final r = judge.judge({4, 2, 3, 1});
    expect(r, isA<PartFound>());
    expect((r as PartFound).part.name, '木');
    expect(r.strokeIds, [1, 2, 3, 4]);
  });

  test('仕様11.6: 同じ部品はどの場所を選んでも正解', () {
    expect((judge.judge({9, 10, 11, 12}) as PartFound).part.name, '木');
    expect((judge.judge({5, 6, 7, 8}) as PartFound).strokeIds, [5, 6, 7, 8]);
  });

  test('仕様11.5: 見つけ済みの部品は2回目は登録されない', () {
    final r = judge.judge({5, 6, 7, 8}, found: {'木'});
    expect(r, isA<PartAlreadyFound>());
  });

  test('仕様11.3 / 11.4: 字そのものも正解・画の重複利用も可', () {
    final r = judge.judge({for (var i = 1; i <= 12; i++) i}, found: {'木', '林'});
    expect((r as PartFound).part.name, '森');
  });

  test('一致しない・余分な画が混じる・空の選択は不正解', () {
    expect(judge.judge({1, 2, 3}), isA<NoMatch>());
    expect(judge.judge({1, 2, 3, 4, 5}), isA<NoMatch>());
    expect(judge.judge({}), isA<NoMatch>());
  });

  test('仕様11.2: ステージの学年より上の漢字・学年外の漢字は部品にならない', () {
    final puzzle = PuzzleData(kanji: 'X', grade: 1, strokeCount: 3, parts: [
      PartData(name: 'A', strokePatterns: [[1]]),
      PartData(name: 'B', strokePatterns: [[2]]),
      PartData(name: 'C', strokePatterns: [[3]]),
    ]);
    final j = PartJudge(
      puzzle: puzzle,
      gradeOf: const {'A': 1, 'B': 2},
      stageGrade: 1,
    );
    expect(j.parts.map((p) => p.name), ['A']);
    expect(j.totalParts, 1);
    expect(j.judge({2}), isA<NoMatch>());

    final grade2 = PartJudge(
      puzzle: puzzle,
      gradeOf: const {'A': 1, 'B': 2},
      stageGrade: 2,
    );
    expect(grade2.parts.map((p) => p.name), ['A', 'B']);
  });
}
