import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class WillOverwriteTooltip extends StatelessWidget {
  const WillOverwriteTooltip({
    required this.reservation,
    required this.localized,
    super.key,
  });

  final Reservation reservation;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<Reservation>>(
      future: context
          .watch<IsarHelper>()
          .reservationActions
          .filterRegistered(<Reservation>[reservation]), 
          //?This was filtering all with one query, but the future builder 
          //?was preventing generalization.
      builder: (
        BuildContext context,
        AsyncSnapshot<Iterable<Reservation>> snapshot,
      ) {
        final bool alreadyExistsInDatabase =
            (snapshot.data ?? <Reservation>[]).isNotEmpty;
        return Positioned(
          left: 0,
          bottom: 0,
          child: alreadyExistsInDatabase
              ? Tooltip(
                  message:
                      localized.willOverwriteExistingReservation.capitalized,
                  child: Icon(
                    Icons.edit_document,
                    color: Theme.of(context).colorScheme.error,
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
