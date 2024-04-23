import "package:decla_time/core/functions/plurals.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DeclaringReservationRouteItem extends StatelessWidget {
  const DeclaringReservationRouteItem({
    required this.reservation,
    required this.localized,
    super.key,
  });

  final Reservation reservation;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(reservation.guestName),
        FittedBox(
          child: Text(
            // ignore: lines_longer_than_80_chars
            "${reservation.arrivalDateString} - ${reservation.departureDateString}",
          ),
        ),
        RowWithSpacings(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(nightOrNights(localized, reservation.nights)),
            const Text("-"),
            Text("${reservation.payout.toStringAsFixed(2)} EUR"),
          ],
        ),
      ],
    );
  }
}
