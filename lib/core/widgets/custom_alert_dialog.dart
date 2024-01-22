// ignore_for_file: prefer_const_constructors

import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.confirmButtonAction,
    required this.title,
    required this.child,
  });

  final void Function() confirmButtonAction;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: kMaxWidthSmall,
        child: child,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(localized.cancel.capitalized)),
        TextButton(
          onPressed: () {
            confirmButtonAction();
          },
          child: Text(localized.confirm.capitalized),
        )
      ],
    );
  }
}
