
import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/reservation_manual_entry_dropdown_field_outline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlatformField extends StatelessWidget {
  const PlatformField({
    super.key,
    required this.localized,
    required this.platformNameController,
  });

  final AppLocalizations localized;
  final TextEditingController platformNameController;

  @override
  Widget build(BuildContext context) {
    return ReservationManualEntryDropdownFieldOutline(
      localized: localized,
      textEditingController: platformNameController,
      sharedPrefsListKey: kBookingPlatforms,
      headlineText: "Platform",
      hintText: "Platform",
      defaultDropdownEntries: ["Airbnb", "Booking.com"]
          .map((platformEntry) =>
              DropdownMenuEntry(value: platformEntry, label: platformEntry))
          .toList(),
    );
  }
}