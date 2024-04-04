import "package:decla_time/declarations/status_indicator_declare/submitting_route/lists/declaring_reservation_route_item.dart";
import "package:decla_time/declarations/status_indicator_import/declarations_import_route/declaration_import_route.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class PendingReservations extends StatelessWidget {
  const PendingReservations({
    required this.pendingReservations,
    required this.localized,
    super.key,
  });

  final List<Reservation> pendingReservations;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return ImportListViewOutline(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final Reservation pendingReservation = pendingReservations[index];

          return ImportListTileOutline(
            child: ListTile(
              trailing: const CircularProgressIndicator(),
              title: DeclaringReservationRouteItem(
                reservation: pendingReservation,
                localized: localized,
              ),
            ),
          );
        },
        itemCount: pendingReservations.length,
      ),
    );
  }
}
