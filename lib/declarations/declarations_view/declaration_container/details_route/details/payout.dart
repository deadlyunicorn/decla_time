import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/reservation_details_container.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class Payout extends StatelessWidget {
  const Payout({
    required this.declaration,
    required this.localized,
    super.key,
  });

  final Declaration declaration;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        OutlineContainer(
          child: Column(
            children: <Widget>[
              Text(
                // ignore: lines_longer_than_80_chars
                "${(declaration.cancellationAmount ?? declaration.payout).toStringAsFixed(2)} €",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              Text(
                "${((declaration.cancellationAmount ?? declaration.payout) / declaration.nights).toStringAsFixed(2)} € / ${localized.night}",
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),
        if (declaration.cancellationAmount != null)
          Positioned(
            top: -16,
            left: -32,
            child: Transform.rotate(
              angle: -0.24,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.error,
                ),
                child: Text(
                  localized.cancelled.capitalized,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
