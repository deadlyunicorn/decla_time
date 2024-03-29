import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/reservation_form.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ManualReservationEntryRoute extends StatelessWidget {
  const ManualReservationEntryRoute({
    required this.addToReservationsFoundSoFar,
    required this.localized,
    super.key,
  });

  final void Function(Iterable<Reservation> list) addToReservationsFoundSoFar;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return RouteOutline(
      title: localized.manualAddition.capitalized,
      child: ReservationForm(
        localized: localized,
        handleFormSubmit: (Reservation reservation) {
          addToReservationsFoundSoFar(<Reservation>[reservation]);
        },
      ),
    );
  }
}
