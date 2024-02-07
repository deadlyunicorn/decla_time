import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequiredTextField extends StatelessWidget {
  const RequiredTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.localized,
    this.refresh,
    this.isEditingExistingEntry = false,
  });

  final TextEditingController controller;
  final String label;
  final AppLocalizations localized;
  final bool isEditingExistingEntry; //? This field is used so that when we edit an entry, we disable editing the ID of the entry.
  final void Function()? refresh;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kMaxContainerWidthSmall * 2,
      child: TextFormField(
        onChanged: ( newValue ){
          final refreshFunction = refresh;
          if ( refreshFunction != null ){
            refreshFunction();
          }
        },
        readOnly: isEditingExistingEntry,
        decoration: InputDecoration(
          errorMaxLines: 2,
          labelText: "${label.capitalized}*",
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
        ),
        controller: controller,
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            if (value.length < 6) {
              return localized.insertAtleastSix.capitalized;
            } else {
              return null;
            }
          } else {
            return localized.insertSomeValue.capitalized;
          }
        },
      ),
    );
  }
}
