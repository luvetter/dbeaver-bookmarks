import 'package:dbeaver_bookmarks/src/common/provider/theme.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const spacer = SizedBox(height: 10.0);
    const biggerSpacer = SizedBox(height: 40.0);
    final themeMode = ref.watch(themeModeProvider);

    return ScaffoldPage.scrollable(
      header: const PageHeader(title: Text('Einstellungen')),
      children: [
        Text('App-Modus', style: FluentTheme.of(context).typography.subtitle),
        spacer,
        ...[ThemeMode.light, ThemeMode.dark, ThemeMode.system].map(
          (mode) => Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8.0),
            child: RadioButton(
              checked: mode == themeMode,
              onChanged: (value) {
                if (value) {
                  ref.read(themeModeProvider.notifier).change(mode);
                }
              },
              content: Text(mode.name),
            ),
          ),
        ),
        biggerSpacer,
      ],
    );
  }
}

extension _ThemeModeExt on ThemeMode {
  String get name => switch (this) {
        ThemeMode.light => 'Hell',
        ThemeMode.dark => 'Dunkel',
        ThemeMode.system => 'System',
      };
}
