import 'package:dbeaver_bookmarks/src/feature/connections/application/configuration_manager.dart';
import 'package:dbeaver_bookmarks/src/feature/connections/domain/connection_configuration.dart';
import 'package:dbeaver_bookmarks/src/localizations/app_localizations.dart';
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
            _LabeledTextBox(
              objectName: context.loc.connection,
              controller: _nameController,
              onFieldSubmitted: (_) => _create(),
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
