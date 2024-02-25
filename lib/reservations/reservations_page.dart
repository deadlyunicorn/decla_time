import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservations_list.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class ReservationsPage extends StatelessWidget {
  const ReservationsPage({
    required this.localized,
    required this.scrollController,
    super.key,
  });

  final AppLocalizations localized;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reservation>>(
      builder:
          (BuildContext context, AsyncSnapshot<List<Reservation>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ReservationsList(
            reservations: snapshot.data ?? <Reservation>[],
            scrollController: scrollController,
            localized: localized,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      future: context
          .watch<IsarHelper>()
          .reservationActions
          .getAllEntriesFromReservations(),
    );
  }
}
