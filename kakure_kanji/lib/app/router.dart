import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/puzzle/puzzle_screen.dart';

/// 画面遷移。漢字は URL ではコードポイント（10進）で表す。
GoRouter createRouter() => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'puzzle/:code',
              builder: (context, state) {
                final code = int.parse(state.pathParameters['code']!);
                return PuzzleScreen(character: String.fromCharCode(code));
              },
            ),
          ],
        ),
      ],
    );
