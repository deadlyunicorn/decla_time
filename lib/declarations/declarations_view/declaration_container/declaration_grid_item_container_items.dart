import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/night_or_nights.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/reservations/presentation/decleration_status_dot.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DeclarationGridItemContainerItems extends StatelessWidget {
  const DeclarationGridItemContainerItems({
    required this.localized,
    required this.declaration,
    super.key,
  });

  final AppLocalizations localized;
  final Declaration declaration;

  @override
  Widget build(BuildContext context) {
    final double? cancellationAmount = declaration.cancellationAmount;
    bool isCancelled = cancellationAmount !=
        null; //TODO add some indicator if it is cancelled.

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (declaration.serialNumber != null)
            Text(
              "${localized.serialNumberShort}: ${declaration.serialNumber ?? ""}",
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          Flexible(
            child: FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    // ignore: lines_longer_than_80_chars
                    "${(cancellationAmount ?? declaration.payout).toStringAsFixed(2)} €",
                    style: Theme.of(context).textTheme.headlineSmall!,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  if (isCancelled)
                    Text(
                      "(${localized.cancelled.capitalized})",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  Text(
                    nightOrNights(localized, declaration.nights),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          DeclarationStatusDot(
            size: 24,
            localized: localized,
            declarationStatus: declaration.declarationStatus,
          ),
        ],
      ),
    );
  }
}
