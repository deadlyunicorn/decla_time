import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ReservationDetailsTooltip extends StatelessWidget {
  const ReservationDetailsTooltip({
    required this.reservation,
    required this.localized,
    super.key,
  });

  final Reservation reservation;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: Tooltip(
        preferBelow: false,
        richMessage: TextSpan(
          children: <InlineSpan>[
            TextSpan(
              text: "ID: ${reservation.id}",
            ),
            const TextSpan(text: "\n"),
            TextSpan(
              text:
                  // ignore: lines_longer_than_80_chars
                  "${localized.listingPlace.capitalized}: ${reservation.listingName ?? localized.other.capitalized}",
            ),
            const TextSpan(text: "\n"),
            TextSpan(
              text:
                  // ignore: lines_longer_than_80_chars
                  "${localized.platform.capitalized}: ${reservation.bookingPlatform}",
            ),
            const TextSpan(text: "\n"),
            TextSpan(
              text:
                  // ignore: lines_longer_than_80_chars
                  "${localized.status.capitalized}: ${reservation.reservationStatus}",
            ),
            const TextSpan(text: "\n"),
            TextSpan(
              text:
                  // ignore: lines_longer_than_80_chars
                  "${localized.arrival.capitalized}: ${reservation.arrivalDateString}",
            ),
            const TextSpan(text: "\n"),
            TextSpan(
              text:
                  // ignore: lines_longer_than_80_chars
                  "${localized.departure.capitalized}: ${reservation.departureDateString}",
            ),
            const TextSpan(text: "\n"),
            TextSpan(
              text:
                  // ignore: lines_longer_than_80_chars
                  "${localized.payout.capitalized}: ${reservation.payout.toStringAsFixed(2)}€",
            ),
          ],
        ),
        child: Icon(
          Icons.info,
          color: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
