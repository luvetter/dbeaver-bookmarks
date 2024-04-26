import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

final themeModeProvider = themeModeNotifierProvider;

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void change(ThemeMode mode) {
    state = mode;
  }
}
