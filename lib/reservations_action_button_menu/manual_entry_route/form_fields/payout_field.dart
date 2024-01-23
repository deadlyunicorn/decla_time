import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PayoutField extends StatelessWidget {
  const PayoutField({
    super.key,
    required this.payoutController,
    required this.localized,
  });

  final TextEditingController payoutController;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kMaxContainerWidthSmall,
      child: TextFormField(
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
        controller: payoutController,
        decoration: InputDecoration(
          errorMaxLines: 2,
          errorStyle: const TextStyle(overflow: TextOverflow.fade),
          helperText: "${localized.format.capitalized}: 120.34",
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (RegExp("^[0-9]+[.][0-9][0-9]\$").hasMatch(value ?? "")) {
            if (double.tryParse(value ?? "") != null) {
            } else {
              return localized.invalidNumber.capitalized;
            }
            return null;
          } else {
            return localized.invalidFormat.capitalized;
          }
        },
      ),
    );
  }
}
