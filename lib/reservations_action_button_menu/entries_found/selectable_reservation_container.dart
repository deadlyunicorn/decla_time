import "package:decla_time/reservations/presentation/widgets/reservation_grid_item_container.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:decla_time/reservations_action_button_menu/entries_found/is_selected_underline.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class SelectableReservationContainer extends StatelessWidget {
  const SelectableReservationContainer({
    required this.localized,
    required this.reservation,
    required this.isSelected,
    super.key,
  });

  final AppLocalizations localized;
  final Reservation reservation;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned(
          child: ReservationGridItemContainerItems(
            //Items.
            localized: localized,
            reservation: reservation,
          ),
        ),
        Positioned(
          bottom: 0,
          child: IsSelectedUnderline(
            isSelected: isSelected,
          ),
        ),
      ],
    );
  }
}
