import 'package:dbeaver_bookmarks/src/localizations/app_localizations.dart';
import 'package:dbeaver_bookmarks/src/localizations/app_localizations_extension.dart';
import 'package:fluent_ui/fluent_ui.dart';

class LabeledTextFormBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onFieldSubmitted;
  final List<Validator> validators;
  final String label;

  const LabeledTextFormBox({
    super.key,
    required this.controller,
    this.onFieldSubmitted,
    this.validators = const [],
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InfoLabel(
      label: label,
      child: TextFormBox(
        maxLines: 1,
        controller: controller,
        autovalidateMode: AutovalidateMode.always,
        onFieldSubmitted: onFieldSubmitted,
        validator: (value) => _AggregateValidator([
          ...validators,
        ]).validate(value, context.loc),
      ),
    );
  }
}

abstract interface class Validator {
  String? validate(String? value, AppLocalizations loc);
}

class NotEmptyValidator implements Validator {
  final String message;

  NotEmptyValidator(this.message);

  @override
  String? validate(String? value, AppLocalizations loc) {
    return value.isNullOrEmpty ? message : null;
  }
}

extension _NullOrEmpty on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

class _AggregateValidator implements Validator {
  final List<Validator> _validators;

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
