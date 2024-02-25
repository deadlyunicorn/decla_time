import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations_action_button_menu/manual_entry_route/reservation_manual_entry_dropdown_field_outline.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class StatusField extends StatelessWidget {
  const StatusField({
    required this.localized,
    required this.reservationStatusController,
    super.key,
  });

  final AppLocalizations localized;
  final TextEditingController reservationStatusController;

  @override
  Widget build(BuildContext context) {
    return ReservationManualEntryDropdownFieldOutline(
      localized: localized,
      textEditingController: reservationStatusController,
      sharedPrefsListKey: kReservationStatus,
      label: "${localized.status}*",
      isRequired: true,
      defaultDropdownEntriesList: <DropdownMenuEntry<String>>[
        DropdownMenuEntry<String>(
          value: kCompleted,
          label: localized.completed.capitalized,
        ),
        DropdownMenuEntry<String>(
          value: kCancelled,
          label: localized.cancelled.capitalized,
        ),
        DropdownMenuEntry<String>(
          value: kUpcoming,
          label: localized.upcoming.capitalized,
        ),
      ],
    );
  }
}
