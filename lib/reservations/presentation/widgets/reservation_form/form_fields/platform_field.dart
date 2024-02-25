import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations_action_button_menu/manual_entry_route/reservation_manual_entry_dropdown_field_outline.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class PlatformField extends StatelessWidget {
  const PlatformField({
    required this.localized,
    required this.platformNameController,
    super.key,
  });

  final AppLocalizations localized;
  final TextEditingController platformNameController;

  @override
  Widget build(BuildContext context) {
    return ReservationManualEntryDropdownFieldOutline(
      localized: localized,
      textEditingController: platformNameController,
      sharedPrefsListKey: kBookingPlatforms,
      label: "${localized.platform}*",
      isRequired: true,
      defaultDropdownEntriesList: <DropdownMenuEntry<String>>[
        const DropdownMenuEntry<String>(value: "airbnb", label: "Airbnb"),
        const DropdownMenuEntry<String>(
          value: "booking_com",
          label: "Booking.com",
        ),
        DropdownMenuEntry<String>(
          value: "no_platform",
          label: localized.other.capitalized,
        ),
      ],
    );
  }
}
