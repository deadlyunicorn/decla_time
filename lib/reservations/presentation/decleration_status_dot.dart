import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter/material.dart";

class DeclarationStatusDot extends StatelessWidget {
  final bool isDeclared;
  final double size;
  final AppLocalizations localized;

  const DeclarationStatusDot({
    required this.isDeclared,
    required this.localized,
    super.key,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          // ignore: lines_longer_than_80_chars
          "${localized.declaration_status.capitalized}: ${isDeclared ? localized.declared : localized.undeclared.capitalized}",
      child: isDeclared
          ? Icon(
              Icons.done,
              size: size,
              color: Colors.green,
            )
          : Icon(
              Icons.cancel,
              size: size,
              color: Theme.of(context).colorScheme.error,
            ),
    );
  }
}
