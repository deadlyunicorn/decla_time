// ignore_for_file: prefer_const_constructors

import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/reservations_action_button_menu/reservation_manual_entry_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListingNameField extends StatelessWidget {
  const ListingNameField({
    super.key,
    required this.localized,
    required this.listingNameController,
  });

  final AppLocalizations localized;
  final TextEditingController listingNameController;

  @override
  Widget build(BuildContext context) {
    return ReservationManualDropdownField(
      localized: localized,
      textEditingController: listingNameController,
      sharedPrefsListKey: kReservationListing,
      headlineText: "Listing name",
      hintText: "Listing",
    );
  }
}
