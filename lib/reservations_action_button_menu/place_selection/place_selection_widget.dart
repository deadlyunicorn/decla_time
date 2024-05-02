import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/animated_drop_down_icon.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/declarations/properties/available_user_properties.dart";
import "package:decla_time/reservations/reservation_place.dart";
import "package:decla_time/reservations_action_button_menu/place_selection/reservation_place_addition_route/reservation_place_addition_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ReservationPlaceSelectionWidget extends StatefulWidget {
  const ReservationPlaceSelectionWidget({
    required this.setSelectedPlaceId,
    required this.availableReservationPlaces,
    required this.selectedPlaceId,
    required this.localized,
    super.key,
  });

  final int? selectedPlaceId;
  final void Function(int) setSelectedPlaceId;
  final List<ReservationPlace> availableReservationPlaces;
  final AppLocalizations localized;

  @override
  State<ReservationPlaceSelectionWidget> createState() =>
      _ReservationPlaceSelectionWidgetState();
}

class _ReservationPlaceSelectionWidgetState
    extends State<ReservationPlaceSelectionWidget> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    final ReservationPlace? selectedPlace = widget.availableReservationPlaces
        .where(
          (ReservationPlace element) => element.id == widget.selectedPlaceId,
        )
        .firstOrNull;

    return SizedBox(
      height: 88,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ColumnWithSpacings(
            spacing: 8,
            children: <Widget>[
              AvailablePropertiesListTile(
                icon: AnimatedDropDownIcon(isOpen: isOpen),
                onTap: () {
                  setState(() {
                    isOpen = !isOpen;
                  });
                  // widget.setSelectedPlaceId(123);
                },
                child: Text(
                  selectedPlace != null
                      ? selectedPlace.friendlyName
                      : widget.localized.noPlaceSelected.capitalized,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isOpen)
                ColumnWithSpacings(
                  spacing: 8,
                  children: <Widget>[
                    ...widget.availableReservationPlaces.map(
                      (ReservationPlace place) => AvailablePropertiesListTile(
                        onTap: () {
                          widget.setSelectedPlaceId(place.id);
                          setState(() {
                            isOpen = false;
                          });
                        },
                        child: Text(place.friendlyName),
                      ),
                    ),
                    AvailablePropertiesListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              ReservationPlaceAdditionRoute(
                            localized: widget.localized,
                          ),
                        );
                      },
                      child: Text(widget.localized.addPlace.capitalized),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
