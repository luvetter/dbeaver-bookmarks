import 'package:fluent_ui/fluent_ui.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

final fluentThemeProvider = fluentThemeNotifierProvider;

@riverpod
class FluentThemeNotifier extends _$FluentThemeNotifier {
  @override
  FluentThemeData build() {
    return FluentThemeData.light();
  }

  void toggle() {
    if (state.brightness == Brightness.light) {
      state = state.copyWith(brightness: Brightness.dark);
    } else {
      state = state.copyWith(brightness: Brightness.light);
    }
  }
}
