import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/plurals.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:decla_time/reservations_action_button_menu/manual_entry_route/manual_reservation_entry_route.dart";
import "package:decla_time/reservations_action_button_menu/reservation_addition_button_outline.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class AddReservationsManuallyButton extends StatelessWidget {
  const AddReservationsManuallyButton({
    required this.localized,
    required this.addToReservationsFoundSoFar,
    super.key,
  });

  final AppLocalizations localized;
  final void Function(Iterable<Reservation>) addToReservationsFoundSoFar;

  @override
  Widget build(BuildContext context) {
    return ReservationAdditionButtonOutline(
      description: localized.manualAddition.capitalized,
      icon: Icons.edit,
      onTap: () async {
        final Reservation? reservation = await Navigator.push<Reservation?>(
          context,
          MaterialPageRoute<Reservation?>(
            builder: (BuildContext context) => ManualReservationEntryRoute(
              localized: localized,
              addToReservationsFoundSoFar: addToReservationsFoundSoFar,
            ),
          ),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();

          if (reservation != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text(
                    // ignore: lines_longer_than_80_chars
                    "${localized.addedAReservation.capitalized}.\n${localized.reservationLasted.capitalized} ${nightOrNights(localized, reservation.nights)}.\n${localized.thePayoutIs.capitalized} ${reservation.payout}€.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Center(
                  child: Text(localized.reservationsNotAdded.capitalized),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
