
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SharedPrefsListStringAdditionAlertDialog extends StatefulWidget {
  const SharedPrefsListStringAdditionAlertDialog({
    super.key,
    required this.refreshParent,
    required this.dropdownMenuEntries,
    required this.title,
    required this.listStringKey,
    required this.hintText,
  });

  final void Function() refreshParent;
  final Set<String> dropdownMenuEntries;
  final String title;
  final String listStringKey;
  final String hintText;

  @override
  State<SharedPrefsListStringAdditionAlertDialog> createState() =>
      _SharedPrefsListStringAdditionAlertDialogState();
}

class _SharedPrefsListStringAdditionAlertDialogState
    extends State<SharedPrefsListStringAdditionAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return CustomAlertDialog(
      title: widget.title,
      confirmButtonAction: () async {
        if (_formKey.currentState!.validate()) {
          Navigator.pop(context, textFieldController.text);

          SharedPreferences.getInstance().then((prefs) {
            prefs.setStringList(widget.listStringKey,
                [...widget.dropdownMenuEntries, textFieldController.text]);
            widget.refreshParent();
          });
        }
      },
      child: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: widget.hintText,
            errorMaxLines: 2,
          ),
          controller: textFieldController,
          validator: (value) {
            if (value!.length < 6) {
              return localized.enterMin6Chars.capitalized;
            } else if (widget.dropdownMenuEntries.contains(value)) {
              return localized.entryAlreadyExists.capitalized;
            }
            return null;
          },
        ),
        //( textController.text.length > 5 ),
      ),
    );
  }
}
