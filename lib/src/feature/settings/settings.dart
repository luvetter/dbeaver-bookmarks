import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = useState(0);
    return ScaffoldPage.scrollable(
      children: [
        const Text('Some Settings here...'),
        for (var i = 0; i < 10; i++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RadioButton(
              checked: index.value == i,
              onChanged: (value) => index.value = i,
              content: Text('Option $i'),
            ),
          ),
      ],
    );
  }
}
