import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DeclarationStatusDot extends StatelessWidget {
  final bool isDeclared;
  final double size;

  const DeclarationStatusDot({
      super.key, 
      required this.isDeclared,
      this.size = 16
    });

  @override
  Widget build(BuildContext context) {

    final localized = AppLocalizations.of(context)!;

    if ( isDeclared ) {
      return Tooltip(
        richMessage: TextSpan(text: localized.declared.capitalized ),
        child: Icon(
          Icons.done,
          size: size,
          color: Colors.green,
        ),
      );
    } else {
      return Tooltip(
        richMessage: TextSpan(text: localized.undeclared.capitalized ),
        child: Icon(
          Icons.cancel,
          size: size,
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
