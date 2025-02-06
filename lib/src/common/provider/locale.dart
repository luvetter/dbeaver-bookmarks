import 'dart:ui' as ui;

import 'package:dbeaver_bookmarks/src/localizations/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale.g.dart';

@riverpod
class Locale extends _$Locale {
  @override
  ui.Locale build() {
    return ui.Locale('de');
  }

  void change(ui.Locale locale) {
    if (AppLocalizations.supportedLocales.contains(locale)) {
      state = locale;
    }
  }
}
