import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/reservation_details_container.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class ReservationDetailsRoute extends StatelessWidget {
  const ReservationDetailsRoute({
    required this.initialReservation,
    required this.localized,
    super.key,
  });

  final Reservation initialReservation;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Reservation?>(
      future: context
          .watch<IsarHelper>()
          .reservationActions
          .getReservationEntry(initialReservation.id),
      builder: (BuildContext context, AsyncSnapshot<Reservation?> snapshot) {
        final Reservation? reservation = snapshot.data;

        return (reservation == null)
            ? snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Text(
                      localized.itemNotFoundLocally.capitalized,
                    ),
                  )
            : RouteOutline(
                title: localized.details.capitalized,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Column(
                        children: <Widget>[
                          ReservationDetailsContainer(
                            reservation: reservation,
                            localized: localized,
                          ),
                          const SizedBox.square(dimension: 32),
                          Text(
                            formatLastEdit(
                              reservation.lastEdit,
                              localized: localized,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  String formatLastEdit(
    DateTime? lastEdit, {
    required AppLocalizations localized,
  }) {
    return lastEdit != null
        // ignore: lines_longer_than_80_chars
        ? "${localized.lastEdit.capitalized}: ${DateFormat("dd/MM/y HH:mm").format(lastEdit)}"
        : "";
  }
}
