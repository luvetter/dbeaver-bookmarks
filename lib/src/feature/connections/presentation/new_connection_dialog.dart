import 'package:dbeaver_bookmarks/src/common/widgets/labeled_text_form_box.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/application/configuration_manager.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/domain/connection_configuration.dart';
import 'package:dbeaver_bookmarks/src/localizations/app_localizations_extension.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewConnectionDialog extends ConsumerStatefulWidget {
  final ConnectionConfiguration configuration;

  const NewConnectionDialog(this.configuration, {super.key});

  @override
  ConsumerState<NewConnectionDialog> createState() =>
      _NewConnectionDialogState();
}

class _NewConnectionDialogState extends ConsumerState<NewConnectionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(context.loc.newConnectionTitle),
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
              label: context.loc.objectName(context.loc.connection),
              controller: _nameController,
              onFieldSubmitted: (_) => _create(),
              validators: [
                NotEmptyValidator(
                  context.loc.enterObjectName(context.loc.connection),
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
      ref.read(configurationManagerProvider.notifier).createConnection(
            widget.configuration.id,
            _nameController.text,
          );
      Navigator.of(context).pop();
    }
  }
}
