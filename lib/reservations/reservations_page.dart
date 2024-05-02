import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/generic_calendar_grid_view/generic_calendar_grid_view.dart";
import "package:decla_time/declarations_action_button_menu/filtering_reservations/reservation_place_selector.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_grid_item.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:decla_time/reservations/reservation_place.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:isar/isar.dart";
import "package:provider/provider.dart";

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({
    required this.localized,
    required this.scrollController,
    super.key,
  });

  final AppLocalizations localized;
  final ScrollController scrollController;

  @override
  State<ReservationsPage> createState() => _ReservationsPageState();
}

class _ReservationsPageState extends State<ReservationsPage> {
  ReservationPlace? selectedReservationPlace;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
        child: ColumnWithSpacings(
          spacing: 8,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Center(
                child: ColumnWithSpacings(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${widget.localized.displayReservationsOf.capitalized}:",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    ReservationPlaceSelector(
                      setSelectedReservationPlace: setSelectedReservationPlace,
                      selectedReservationPlace: selectedReservationPlace,
                      localized: widget.localized,
                    ),
                  ],
                ),
              ),
            ),
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
                    localized: widget.localized,
                    child: (Reservation reservation) => ReservationContainer(
                      localized: widget.localized,
                      reservation: reservation,
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
              future: getReservationsOf(
                reservationPlace: selectedReservationPlace,
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setSelectedReservationPlace(ReservationPlace? newPlace) {
    if (newPlace != selectedReservationPlace) {
      setState(() {
        selectedReservationPlace = newPlace;
      });
    }
  }

  Future<List<Reservation>> getReservationsOf({
    required ReservationPlace? reservationPlace,
    required BuildContext context,
  }) async {
    final Isar isar = await context.read<IsarHelper>().isarFuture;

    return reservationPlace != null
        ? await isar.reservations
            .filter()
            .reservationPlaceIdEqualTo(reservationPlace.id)
            .sortByDepartureDateDesc()
            .findAll()
        : await isar.reservations.where().sortByDepartureDateDesc().findAll();
  }
}
