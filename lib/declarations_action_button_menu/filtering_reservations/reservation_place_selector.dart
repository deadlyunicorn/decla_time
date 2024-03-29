import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/declarations/properties/available_user_properties.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class ReservationPlaceSelector extends StatefulWidget {
  const ReservationPlaceSelector({
    required this.setSelectedReservationPlace,
    required this.selectedReservationPlace,
    required this.localized,
    super.key,
  });

  final void Function(String) setSelectedReservationPlace;
  final String selectedReservationPlace;
  final AppLocalizations localized;

  @override
  State<ReservationPlaceSelector> createState() =>
      _ReservationPlaceSelectorState();
}

class _ReservationPlaceSelectorState extends State<ReservationPlaceSelector> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final String menuText = widget.selectedReservationPlace.isEmpty
        ? widget.localized.displayAll.capitalized
        : widget.selectedReservationPlace;

    return FutureBuilder<Set<String>>(
      future:
          context.watch<IsarHelper>().reservationActions.getReservationPlaces(),
      builder: (BuildContext context, AsyncSnapshot<Set<String>> snapshot) {
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
                (String reservationPlace) {
                  final String entryText = reservationPlace;

                  return AvailablePropertiesListTile(
                    onTap: () async {
                      widget.setSelectedReservationPlace(reservationPlace);
                      setState(() {
                        isOpen = false;
                      });
                    },
                    child: Text(
                      entryText,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
              AvailablePropertiesListTile(
                onTap: () async {
                  widget.setSelectedReservationPlace("");
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
    );
  }
}
