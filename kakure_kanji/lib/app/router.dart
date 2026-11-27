import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/dictionary/dictionary_screen.dart';
import '../features/home/home_screen.dart';
import '../features/puzzle/puzzle_screen.dart';
import '../features/stage/grade_select_screen.dart';
import '../features/stage/stage_select_screen.dart';

/// 画面遷移（仕様 24 / 25）。漢字は URL ではコードポイント（10進）で表す。
///
/// ホーム → 学年選択 → ステージ選択 → 問題 →（結果）、別系統で図鑑。
GoRouter createRouter({String initialLocation = '/'}) => GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'dictionary',
              builder: (context, state) => const DictionaryScreen(),
            ),
            GoRoute(
              path: 'grades',
              builder: (context, state) => const GradeSelectScreen(),
              routes: [
                GoRoute(
                  path: ':grade',
                  builder: (context, state) => StageSelectScreen(
                    grade: int.parse(state.pathParameters['grade']!),
                  ),
                  routes: [
                    GoRoute(
                      path: ':code',
                      builder: (context, state) => PuzzleScreen(
                        key: ValueKey(state.pathParameters['code']),
                        character: String.fromCharCode(
                          int.parse(state.pathParameters['code']!),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
