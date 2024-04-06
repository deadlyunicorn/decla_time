import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DeclarationStatusDot extends StatelessWidget {
  final DeclarationStatus declarationStatus;
  final double size;
  final AppLocalizations localized;

  const DeclarationStatusDot({
    required this.declarationStatus,
    required this.localized,
    super.key,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    String message = "";
    Widget icon = const SizedBox.shrink();

    switch (declarationStatus) {
      case DeclarationStatus.finalized:
        message = localized.declarationStatusFinalized;
        icon = Icon(
          Icons.done_rounded,
          size: size,
          color: Theme.of(context).colorScheme.surface,
        );
        break;
      case DeclarationStatus.temporary:
        message = localized.declarationStatusTemporary;
        icon = Icon(
          Icons.warning_rounded,
          size: size,
          color: Colors.amber,
        );
        break;

      case DeclarationStatus.undeclared:
      default:
        message = localized.declarationStatusUndeclared;
        icon = Icon(
          Icons.cancel,
          size: size,
          color: Theme.of(context).colorScheme.error,
        );
        break;
    }

    return Tooltip( //TODO: When clicking prompt to temporary declaration
      message:
          "${localized.declaration_status.capitalized}: ${message.capitalized}",
      child: icon,
    );
  }
}
