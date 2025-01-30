import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'src/app.dart';

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isDesktop) {
    // await flutter_acrylic.Window.initialize();
    // if (defaultTargetPlatform == TargetPlatform.windows) {
    //   await flutter_acrylic.Window.hideWindowControls();
    // }
    await WindowManager.instance.ensureInitialized();
    await windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: true,
      );
      await windowManager.setMinimumSize(const Size(500, 600));
      await windowManager.show();
    });
  }

  runApp(
    const ProviderScope(
      child: DbeaverBookmarks(),
    ),
  );
}
