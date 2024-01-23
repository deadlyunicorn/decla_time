// ignore_for_file: prefer_const_constructors

import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/reservations_action_button_menu/reservation_manual_entry_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusField extends StatelessWidget {
  const StatusField({
    super.key,
    required this.localized,
    required this.reservationStatusController,
  });

  final AppLocalizations localized;
  final TextEditingController reservationStatusController;

  @override
  Widget build(BuildContext context) {
    return ReservationManualDropdownField(
      localized: localized,
      textEditingController: reservationStatusController,
      sharedPrefsListKey: kReservationStatus,
      headlineText: "Status",
      hintText: "Status",
      defaultDropdownEntries: [
        DropdownMenuEntry(
          value: kCompleted,
          label: localized.completed.capitalized,
        ),
        DropdownMenuEntry(
          value: kCancelled,
          label: localized.cancelled.capitalized,
        ),
        DropdownMenuEntry(
          value: kUpcoming,
          label: localized.upcoming.capitalized,
        ),
      ],
    );
  }
}
