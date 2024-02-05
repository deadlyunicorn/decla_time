import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WillOverwriteTooltip extends StatelessWidget {
  const WillOverwriteTooltip({
    super.key,
    required this.reservationAlreadyInDatabase,
    required this.localized,
  });

  final bool reservationAlreadyInDatabase;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: reservationAlreadyInDatabase
          ? Tooltip(
              message: localized.willOverwriteExistingReservation.capitalized,
              child: Icon(
                Icons.edit_document,
                color: Theme.of(context).colorScheme.error,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
