import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'app/router.dart';

void main() {
  registerAppLicenses();
  runApp(const ProviderScope(child: KakureKanjiApp()));
}

/// 仕様書 7.2: AnimCJK の字形データに適用される Arphic Public License を同梱し、
/// アプリ内のライセンス画面に表示する。
void registerAppLicenses() {
  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString('assets/licenses/ARPHICPL.TXT');
    yield LicenseEntryWithLineBreaks(
      const ['AnimCJK (字形データ / Arphic Public License)'],
      'AnimCJK 2016-2026 Copyright FM-SH, https://github.com/parsimonhi/animCJK\n\n$text',
    );
  });
}

class KakureKanjiApp extends StatefulWidget {
  const KakureKanjiApp({super.key, this.router});

  final GoRouter? router;

  @override
  State<KakureKanjiApp> createState() => _KakureKanjiAppState();
}

class _KakureKanjiAppState extends State<KakureKanjiApp> {
  late final GoRouter _router = widget.router ?? createRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'かくれ漢字',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
      ),
      routerConfig: _router,
    );
  }
}
