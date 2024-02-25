import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/reservation_form.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class ReservationEditingRoute extends StatelessWidget {
  const ReservationEditingRoute({
    required this.reservation,
    required this.localized,
    super.key,
  });

  final Reservation reservation;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return RouteOutline(
      title: localized.reservationEntryChange.capitalized,
      child: ReservationForm(
        arrivalDate: reservation.arrivalDate,
        departureDate: reservation.departureDate,
        guestName: reservation.guestName,
        id: reservation.id,
        listingName: reservation.listingName,
        payout: reservation.payout.toStringAsFixed(2),
        platformName: reservation.bookingPlatform,
        reservationStatus: reservation.reservationStatus,
        localized: localized,
        handleFormSubmit: (Reservation editedReservation) {
          if (!editedReservation.isEqualTo(reservation)) {
            editedReservation.lastEdit = DateTime.now();
            context
                .read<IsarHelper>()
                .reservationActions
                .insertOrUpdateReservationEntry(editedReservation);
          }
        },
      ),
    );
  }
}
