import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/generic_calendar_grid_view/generic_calendar_grid_view.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_grid_item.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
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
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
        child: ColumnWithSpacings(
          spacing: 8,
          children: <Widget>[
            //TODO HERE. -> Make it so that we add reservations to propertyIds - Link properties with local properties.
            FutureBuilder<List<Reservation>>(
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Reservation>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GenericCalendarGridView<Reservation>(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 120,
                    ),
                    items: snapshot.data ?? <Reservation>[],
                    localized: localized,
                    child: (Reservation reservation) => ReservationContainer(
                      localized: localized,
                      reservation: reservation,
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
              future: context
                  .watch<IsarHelper>()
                  .reservationActions
                  .getAllEntriesFromReservations(),
            ),
          ],
        ),
      ),
    );
  }
}
