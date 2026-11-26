import 'dart:convert';

/// 部品漢字（仕様 10.3 / 26.2 PartData）。
///
/// [strokePatterns] は問題漢字の画番号（1始まり）の組み合わせ。
/// 同じ部品が複数箇所にあるときは、パターンを複数持つ（仕様 11.6）。
class PartData {
  PartData({required this.name, required List<List<int>> strokePatterns})
      : strokePatterns = [
          for (final p in strokePatterns) List.unmodifiable([...p]..sort()),
        ];

  factory PartData.fromJson(Map<String, dynamic> json) => PartData(
        name: json['name'] as String,
        strokePatterns: [
          for (final p in json['strokePatterns'] as List)
            [for (final id in p as List) id as int],
        ],
      );

  final String name;
  final List<List<int>> strokePatterns;

  Map<String, dynamic> toJson() =>
      {'name': name, 'strokePatterns': strokePatterns};
}

/// 問題漢字（仕様 26.1 PuzzleData）。
class PuzzleData {
  PuzzleData({
    required this.kanji,
    required this.grade,
    required this.strokeCount,
    required this.parts,
  });

  factory PuzzleData.fromJson(Map<String, dynamic> json, {required int grade}) =>
      PuzzleData(
        kanji: json['kanji'] as String,
        grade: grade,
        strokeCount: json['strokeCount'] as int,
        parts: [
          for (final p in json['parts'] as List)
            PartData.fromJson(p as Map<String, dynamic>),
        ],
      );

  final String kanji;

  /// 配当学年（1〜6）。おまけ（学年外）は 0。
  final int grade;
  final int strokeCount;
  final List<PartData> parts;
}

/// grade_N.json / bonus.json 1ファイル分。
///
/// `kanji` はその学年の配当漢字すべて（学年制限の判定に使う。仕様 11.2）。
///
/// ```json
/// {"grade": 1, "kanji": "一右雨…", "puzzles": [
///   {"kanji": "木", "strokeCount": 4,
///    "parts": [{"name": "木", "strokePatterns": [[1,2,3,4]]}]}
/// ]}
/// ```
class GradeData {
  GradeData({
    required this.grade,
    required this.kanji,
    required this.puzzles,
  });

  factory GradeData.fromJsonString(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    final grade = json['grade'] as int;
    return GradeData(
      grade: grade,
      kanji: [for (final r in (json['kanji'] as String? ?? '').runes)
        String.fromCharCode(r)],
      puzzles: [
        for (final p in json['puzzles'] as List)
          PuzzleData.fromJson(p as Map<String, dynamic>, grade: grade),
      ],
    );
  }

  final int grade;

  /// この学年の配当漢字（1文字ずつ）。
  final List<String> kanji;
  final List<PuzzleData> puzzles;
}
