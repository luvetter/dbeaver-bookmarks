import 'package:dbeaver_bookmarks/src/feature/connections/application/configuration_manager.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/data/connection_configuration_repository.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/domain/connection_configuration.dart';
import 'package:dbeaver_bookmarks/src/localizations/app_localizations.dart';
import 'package:dbeaver_bookmarks/src/localizations/app_localizations_extension.dart';
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

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(context.loc.newConfigurationTitle),
      actions: [
        Button(
          onPressed: () => _create(),
          child: Text(context.loc.createCommand),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.loc.cancelCommand),
        ),
      ],
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LabeledTextBox(
              objectName: context.loc.project,
              controller: _projectController,
              onFieldSubmitted: (_) => _create(),
            ),
            _LabeledTextBox(
              objectName: context.loc.configuration,
              controller: _nameController,
              onFieldSubmitted: (_) => _create(),
              validators: [
                _NameValidator(
                  ref.watch(configurationsByProjectProvider),
                  _projectController,
                ),
              ],
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

extension _NullOrEmpty on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

class _LabeledTextBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;
  final List<_Validator> validators;
  final String objectName;

  const _LabeledTextBox({
    required this.controller,
    this.onFieldSubmitted,
    this.validators = const [],
    required this.objectName,
  });

  @override
  Widget build(BuildContext context) {
    return InfoLabel(
      label: context.loc.objectName(objectName),
      child: TextFormBox(
        maxLines: 1,
        controller: controller,
        autovalidateMode: AutovalidateMode.always,
        onFieldSubmitted: onFieldSubmitted,
        validator: (value) => _AggregateValidator([
          _NotEmptyValidator(objectName),
          ...validators,
        ]).validate(value, context.loc),
      ),
    );
  }
}

abstract interface class _Validator {
  String? validate(String? value, AppLocalizations loc);
}

class _AggregateValidator implements _Validator {
  final List<_Validator> _validators;

  const _AggregateValidator(this._validators);

  @override
  String? validate(String? value, AppLocalizations loc) {
    for (var validator in _validators) {
      var result = validator.validate(value, loc);
      if (result != null) {
        return result;
      }
    }
    return null;
  }
}

class _NotEmptyValidator implements _Validator {
  final String objectName;

  _NotEmptyValidator(this.objectName);

  @override
  String? validate(String? value, AppLocalizations loc) {
    if (value.isNullOrEmpty) {
      return loc.enterObjectName(objectName);
    }
    return null;
  }
}

class _NameValidator implements _Validator {
  final Map<String, List<ConnectionConfiguration>> existingConfigs;
  final TextEditingController projectController;

  _NameValidator(this.existingConfigs, this.projectController);

  @override
  String? validate(String? value, AppLocalizations loc) {
    final String project = projectController.text;
    if (existingConfigs.containsKey(project) &&
        existingConfigs[project]!.any((conf) => conf.name == value)) {
      return loc.configurationAlreadyExists(value!, project);
    }
    return null;
  }
}
