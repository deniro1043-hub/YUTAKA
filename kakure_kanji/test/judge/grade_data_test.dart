import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kakure_kanji/features/judge/puzzle_data.dart';
import 'package:kakure_kanji/features/judge/puzzle_repository.dart';

import '../glyph/test_glyphs.dart';

/// 同梱の判定データ（assets/json/grade_N.json）が仕様のルールを満たすか検査する。
void main() {
  const gradeSizes = {1: 80, 2: 160, 3: 200, 4: 202, 5: 193, 6: 191};
  final grades = [
    for (final g in kAvailableGrades)
      GradeData.fromJsonString(
        File('assets/json/grade_$g.json').readAsStringSync(),
      ),
  ];
  final gradeOf = {
    for (final g in grades)
      for (final k in g.kanji) k: g.grade,
  };

  for (final grade in grades) {
    group('grade_${grade.grade}.json', () {
      test('配当漢字の数が仕様5.1どおりで重複がない', () {
        expect(grade.kanji.length, gradeSizes[grade.grade]);
        expect(grade.kanji.toSet().length, grade.kanji.length);
      });

      for (final puzzle in grade.puzzles) {
        test('問題「${puzzle.kanji}」', () {
          expect(grade.kanji, contains(puzzle.kanji),
              reason: '問題漢字はその学年の配当漢字');
          final glyph = loadTestGlyph(puzzle.kanji);
          expect(puzzle.strokeCount, glyph.strokeCount, reason: '画数が字形と一致');

          final names = puzzle.parts.map((p) => p.name).toList();
          expect(names.toSet().length, names.length, reason: '仕様11.5 同じ部品名は1回のみ');
          expect(names, contains(puzzle.kanji), reason: '仕様11.3 字そのものも正解');
          final self = puzzle.parts.firstWhere((p) => p.name == puzzle.kanji);
          expect(self.strokePatterns,
              anyElement(equals([for (var i = 1; i <= puzzle.strokeCount; i++) i])));

          final seen = <String, String>{};
          for (final part in puzzle.parts) {
            final partGrade = gradeOf[part.name];
            expect(partGrade, isNotNull, reason: '仕様11.1 ${part.name} は配当漢字');
            expect(partGrade, lessThanOrEqualTo(grade.grade),
                reason: '仕様11.2 ${part.name} は学年制限内');
            expect(File('assets/animcjk/${part.name.runes.first}.svg').existsSync(),
                isTrue, reason: '${part.name} の字形 SVG が同梱されている');
            for (final pattern in part.strokePatterns) {
              expect(pattern, isNotEmpty);
              expect(pattern.toSet().length, pattern.length);
              expect(pattern.every((id) => id >= 1 && id <= puzzle.strokeCount),
                  isTrue, reason: '${part.name} $pattern は画番号の範囲内');
              final key = pattern.join(',');
              expect(seen[key], isNull,
                  reason: '仕様17 同じ画の組み合わせが ${seen[key]} と ${part.name} で重複');
              seen[key] = part.name;
            }
          }
        });
      }
    });
  }
}
