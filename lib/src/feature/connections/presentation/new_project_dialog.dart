import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../application/projects_manager.dart';

class NewProjectDialog extends HookConsumerWidget {
  const NewProjectDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var globalKey = useMemoized(() => GlobalKey<FormFieldState<String>>());
    var names = ref.watch(projectsManagerProvider
        .select((projects) => projects.map((p) => p.name)));
    return ContentDialog(
      title: Text('New Project'),
      actions: [
        Button(
          onPressed: () => _create(globalKey, ref, context),
          child: Text('Create'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InfoLabel(
            label: 'Project name',
            child: TextFormBox(
              key: globalKey,
              maxLines: 1,
              autovalidateMode: AutovalidateMode.always,
              onFieldSubmitted: (_) => _create(globalKey, ref, context),
              validator: _NameValidator(names).call,
            ),
          ),
        ],
      ),
    );
  }

  void _create(
    GlobalKey<FormFieldState<String>> globalKey,
    WidgetRef ref,
    BuildContext context,
  ) {
    if (globalKey.currentState!.validate()) {
      ref
          .read(projectsManagerProvider.notifier)
          .createProject(globalKey.currentState!.value!);
      Navigator.of(context).pop();
    }
  }
}

class _NameValidator {
  final Iterable<String> _knownNames;

  _NameValidator(this._knownNames);

  String? call(String? value) {
    if (value.isNullOrEmpty) {
      return 'Please enter a project name';
    }
    if (_knownNames.contains(value)) {
      return "Project '$value' already exists";
    }
    return null;
  }
}

extension _NullOrEmpty on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
