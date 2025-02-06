import 'package:dbeaver_bookmarks/src/common/widgets/labeled_text_form_box.dart';
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
            LabeledTextFormBox(
              label: context.loc.objectName(context.loc.project),
              controller: _projectController,
              onFieldSubmitted: (_) => _create(),
              validators: [
                NotEmptyValidator(
                  context.loc.enterObjectName(context.loc.project),
                ),
              ],
            ),
            LabeledTextFormBox(
              label: context.loc.objectName(context.loc.configuration),
              controller: _nameController,
              onFieldSubmitted: (_) => _create(),
              validators: [
                NotEmptyValidator(
                  context.loc.enterObjectName(context.loc.configuration),
                ),
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

class _NameValidator implements Validator {
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
