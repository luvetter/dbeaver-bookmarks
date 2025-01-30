import 'package:dbeaver_bookmarks/src/feature/connections/application/configuration_manager.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/data/connection_configuration_repository.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/domain/connection_configuration.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewConfigurationDialog extends ConsumerStatefulWidget {
  const NewConfigurationDialog({super.key});

  @override
  ConsumerState<NewConfigurationDialog> createState() =>
      _NewConfigurationDialogState();
}

class _NewConfigurationDialogState
    extends ConsumerState<NewConfigurationDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  late _NameValidator _nameValidator;

  @override
  void initState() {
    super.initState();
    _nameValidator = _NameValidator(ref.read(configurationsByProjectProvider));
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text('New Configuration'),
      actions: [
        Button(
          onPressed: () => _create(),
          child: Text('Create'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoLabel(
              label: 'Project name',
              child: TextFormBox(
                maxLines: 1,
                controller: _projectController,
                autovalidateMode: AutovalidateMode.always,
                onFieldSubmitted: (_) => _create(),
                validator: (value) {
                  if (value.isNullOrEmpty) {
                    return 'Please enter a project name';
                  }
                  return null;
                },
              ),
            ),
            InfoLabel(
              label: 'Configuration name',
              child: TextFormBox(
                maxLines: 1,
                controller: _nameController,
                autovalidateMode: AutovalidateMode.always,
                onFieldSubmitted: (_) => _create(),
                validator: (value) => _nameValidator.validate(
                  value,
                  _projectController.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _create() {
    if (_formKey.currentState!.validate()) {
      ref.read(configurationManagerProvider.notifier).createConfiguration(
            name: _nameController.text,
            project: _projectController.text,
          );
      Navigator.of(context).pop();
    }
  }
}

class _NameValidator {
  final Map<String, List<ConnectionConfiguration>> _existingConfigs;

  _NameValidator(this._existingConfigs);

  String? validate(String? name, String? project) {
    if (name.isNullOrEmpty) {
      return 'Please enter a configuration name';
    }
    if (_existingConfigs.containsKey(project) &&
        _existingConfigs[project]!.any((conf) => conf.name == name)) {
      return "Configuration '$name' for '$project' already exists";
    }
    return null;
  }
}

extension _NullOrEmpty on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
