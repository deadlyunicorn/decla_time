import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/item_select/generic_item_select_grid.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/declarations_action_button_menu/confirm_dialog/start_declaring_dialog.dart";
import "package:decla_time/declarations_action_button_menu/filtering_reservations/reservation_place_selector.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:decla_time/reservations_action_button_menu/entries_found/selectable_reservation_container.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class DeclarationSubmitRoute extends StatefulWidget {
  //TODO HERE I AM RIGHT NOW, be sure to test those.
  const DeclarationSubmitRoute({
    required this.localized,
    required this.selectedProperty,
    super.key,
  });

  final AppLocalizations localized;
  final UserProperty selectedProperty;

  @override
  State<DeclarationSubmitRoute> createState() => _DeclarationSubmitRouteState();
}

class _DeclarationSubmitRouteState extends State<DeclarationSubmitRoute> {
  String selectedReservationPlace = "";

  @override
  Widget build(BuildContext context) {
    return RouteOutline(
      title: widget.localized.submitTemporaryDeclarations.capitalized,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: kMaxWidthLargest,
          child: ColumnWithSpacings(
            spacing: 16,
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  // ignore: lines_longer_than_80_chars
                  "${widget.localized.declaringFor.capitalized}: ${widget.selectedProperty.friendlyName != null ? "${widget.selectedProperty.friendlyName}\n" : ""}${widget.selectedProperty.formattedPropertyDetails}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.localized.selectReservationToSubmitDeclarationsFor
                      .capitalized,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              ReservationPlaceSelector(
                selectedReservationPlace: selectedReservationPlace,
                setSelectedReservationPlace: setSelectedReservationPlace,
                localized: widget.localized,
              ),
              FutureBuilder<List<Reservation>>(
                future: selectedReservationPlace.isEmpty
                    ? context
                        .watch<IsarHelper>()
                        .reservationActions
                        .getAllEntriesFromReservations()
                    : context
                        .watch<IsarHelper>()
                        .reservationActions
                        .getReservationsByPlace(
                          selectedReservationPlace,
                        ),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Reservation>> snapshot,
                ) {
                  final List<Reservation> reservations =
                      snapshot.data ?? <Reservation>[];

                  return Expanded(
                    child: ItemsFoundList<Reservation>(
                      mainAxisSpacing: 36,
                      items: reservations,
                      localized: widget.localized,
                      positionedChildren: ({
                        required Reservation item,
                        required AppLocalizations localized,
                      }) =>
                          <Widget>[
                        Positioned(
                          top: -16,
                          child: Text(item.departureDateString),
                        ),
                      ],
                      selectedItemsHandler: ({
                        required Set<int> setOfIndicesOfSelectedItems,
                      }) {
                        return TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  StartDeclaringDialog(
                                propertyId: widget.selectedProperty.propertyId,
                                localized: widget.localized,
                                reservationToBeSubmitted:
                                    setOfIndicesOfSelectedItems
                                        .map((int index) => reservations[index])
                                        .toList(),
                              ),
                            );
                          },
                          child:
                              Text(widget.localized.submitSelected.capitalized),
                        );
                      },
                      child: ({
                        required bool isSelected,
                        required Reservation item,
                        required AppLocalizations localized,
                      }) =>
                          SelectableReservationContainer(
                        localized: localized,
                        reservation: item,
                        isSelected: isSelected,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setSelectedReservationPlace(String newPlace) {
    setState(() {
      selectedReservationPlace = newPlace;
    });
  }
}
