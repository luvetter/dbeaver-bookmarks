import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContextMenu extends HookWidget {
  final List<ContextMenuItem> items;

  final Widget child;

  const ContextMenu({super.key, required this.items, required this.child});

  @override
  Widget build(BuildContext context) {
    final contextController = useMemoized(() => FlyoutController());
    final contextAttachKey = useMemoized(() => GlobalKey());

    return GestureDetector(
      onSecondaryTapUp: (d) {
        // This calculates the position of the flyout according to the parent navigator
        final targetContext = contextAttachKey.currentContext;
        if (targetContext == null) return;
        final box = targetContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(
          d.localPosition,
          ancestor: Navigator.of(context).context.findRenderObject(),
        );

        contextController.showFlyout(
          barrierColor: Colors.black.withValues(alpha: 0.1),
          position: position,
          builder: (context) {
            return FlyoutContent(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...items.map(
                    (item) => IconButton(
                      icon: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconTheme.merge(
                          data: const IconThemeData(size: 16),
                          child: Icon(item.icon),
                        ),
                        const SizedBox(width: 10.0),
                        Text(item.title),
                      ]),
                      onPressed: item.onPressed != null
                          ? () {
                              item.onPressed!();
                              Navigator.pop(context);
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: FlyoutTarget(
        key: contextAttachKey,
        controller: contextController,
        child: child,
      ),
    );
  }
}

class ContextMenuItem with Diagnosticable {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  ContextMenuItem({
    required this.title,
    required this.icon,
    this.onPressed,
  });
}
