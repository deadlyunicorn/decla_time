import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/widgets/item_select/generic_item_select_grid.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/declarations_action_button_menu/filtering_reservations/reservation_place_selector.dart";
import "package:decla_time/reservations/reservation.dart";
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
      title: "SUBMIT DECLARATIONS LOCALIZED", //TODO
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SizedBox(
          width: kMaxWidthLargest,
          child: Column(
            children: <Widget>[
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Select reservations to declare for ${widget.selectedProperty.friendlyName ?? ""}\n${widget.selectedProperty.formattedPropertyDetails}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              ReservationPlaceSelector(
                selectedReservationPlace: selectedReservationPlace,
                setSelectedReservationPlace: setSelectedReservationPlace,
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
                        .getReservationsByPlace(selectedReservationPlace),
                builder: (context, snapshot) {
                  return Expanded(
                    child: ItemsFoundList<Reservation>(
                      items: snapshot.data ?? [],
                      removeFromItemsFoundSoFar: (p0) {},
                      localized: widget.localized,
                      positionedChildren:
                          ({required item, required localized}) => [],
                      selectedItemsHandler: (
                          {required setOfIndicesOfSelectedItems}) {
                        return Text("hello");
                      },
                      child: (
                              {required isSelected,
                              required item,
                              required localized}) =>
                          Text("hello"),
                    ),
                  );
                  ;
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
