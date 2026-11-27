import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

/// ホーム画面（仕様 24.1）。
///
/// メダル・キャラクター・設定は Phase5 以降で作るので、今は「じゅんびちゅう」。
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('かくれ漢字'),
        actions: [
          IconButton(
            tooltip: 'ライセンス',
            icon: const Icon(Icons.info_outline),
            onPressed: () => showLicensePage(
              context: context,
              applicationName: 'かくれ漢字',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _MenuButton(
                  key: const ValueKey('menu-start'),
                  icon: Icons.play_arrow_rounded,
                  label: 'スタート',
                  primary: true,
                  onPressed: () => context.push('/grades'),
                ),
                _MenuButton(
                  key: const ValueKey('menu-dictionary'),
                  icon: Icons.menu_book_rounded,
                  label: 'ずかん',
                  onPressed: () => context.push('/dictionary'),
                ),
                const _MenuButton(
                  icon: Icons.military_tech_rounded,
                  label: 'メダル（じゅんびちゅう）',
                ),
                const _MenuButton(
                  icon: Icons.pets_rounded,
                  label: 'キャラクター（じゅんびちゅう）',
                ),
                const _MenuButton(
                  icon: Icons.settings_rounded,
                  label: 'せってい（じゅんびちゅう）',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.primary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(64)),
      textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 20)),
      alignment: Alignment.centerLeft,
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 24),
      ),
    );
    final child = Row(
      children: [
        Icon(icon),
        const SizedBox(width: 16),
        // 画面が狭いときは折り返す（はみ出さない）
        Expanded(child: Text(label, softWrap: true)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: primary
          ? FilledButton(onPressed: onPressed, style: style, child: child)
          : OutlinedButton(onPressed: onPressed, style: style, child: child),
    );
  }
}
