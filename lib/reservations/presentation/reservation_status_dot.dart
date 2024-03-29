import "package:decla_time/core/enums/reservation_status.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/translate_reservation_status.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ReservationStatusDot extends StatelessWidget {
  final String reservationStatusString;
  final double size;
  final AppLocalizations localized;

  const ReservationStatusDot({
    required this.reservationStatusString,
    required this.localized,
    super.key,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    ReservationStatus reservationStatus =
        translateReservationStatus(reservationStatusString, localized);

    Color iconColor = Theme.of(context)
        .colorScheme
        .surface; //?surface color looks like green.
    String message = "${localized.status.capitalized}: ";

    switch (reservationStatus) {
      case ReservationStatus.completed:
        message += localized.completed.capitalized;
        break;
      case ReservationStatus.upcoming:
        message +=
            "${localized.upcoming.capitalized} ( $reservationStatusString )";
        iconColor = Colors.amber;
        break;
      case ReservationStatus.cancelled:
        message += localized.cancelled.capitalized;
        iconColor = Theme.of(context).colorScheme.error;
        break;
    }

    return Tooltip(
      message: message,
      child: Icon(
        Icons.circle,
        size: size,
        color: iconColor,
      ),
    );
  }
}
