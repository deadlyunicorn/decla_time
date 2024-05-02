import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/declarations/properties/available_user_properties.dart";
import "package:decla_time/reservations/reservation_place.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:isar/isar.dart";
import "package:provider/provider.dart";

class ReservationPlaceSelector extends StatefulWidget {
  const ReservationPlaceSelector({
    required this.setSelectedReservationPlace,
    required this.selectedReservationPlace,
    required this.localized,
    super.key,
  });

  final void Function(ReservationPlace?) setSelectedReservationPlace;
  final ReservationPlace? selectedReservationPlace;
  final AppLocalizations localized;

  @override
  State<ReservationPlaceSelector> createState() =>
      _ReservationPlaceSelectorState();
}

class _ReservationPlaceSelectorState extends State<ReservationPlaceSelector> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final String menuText = widget.selectedReservationPlace == null
        ? widget.localized.displayAll.capitalized
        : widget.selectedReservationPlace!.friendlyName;

    return SizedBox(
      height: isOpen ? 88 : null,
      child: SingleChildScrollView(
        child: FutureBuilder<List<ReservationPlace>>(
          future: getReservationPlacesFromDatabase(context: context),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<ReservationPlace>> snapshot,
          ) {
            return ColumnWithSpacings(
              spacing: 4,
              children: <Widget>[
                AvailablePropertiesListTile(
                  onTap: () {
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  child: Text(menuText),
                ),
                if (isOpen) ...<Widget>[
                  ...?snapshot.data?.map(
                    (ReservationPlace reservationPlace) {
                      return AvailablePropertiesListTile(
                        onTap: () async {
                          widget.setSelectedReservationPlace(reservationPlace);
                          setState(() {
                            isOpen = false;
                          });
                        },
                        child: Text(
                          reservationPlace.friendlyName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                  AvailablePropertiesListTile(
                    onTap: () async {
                      widget.setSelectedReservationPlace(null);
                      setState(() {
                        isOpen = false;
                      });
                    },
                    child: Text(
                      widget.localized.displayAll.capitalized,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Future<List<ReservationPlace>> getReservationPlacesFromDatabase({
    required BuildContext context,
  }) async {
    final Isar isar = await context.read<IsarHelper>().isarFuture;

    return await isar.reservationPlaces.where().findAll();
  }
}
