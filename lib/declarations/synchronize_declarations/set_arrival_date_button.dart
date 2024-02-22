import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/handle_range_date_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SetArrivalDateButton extends StatelessWidget {
  const SetArrivalDateButton({
    super.key,
    required this.arrivalDate,
    required this.departureDate,
    required this.localized,
    required this.setArrivalDate,
  });

  final DateTime? arrivalDate;
  final DateTime? departureDate;
  final AppLocalizations localized;
  final void Function(DateTime?) setArrivalDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Arrival:"),
        TextButton(
            onPressed: () async {
              final tempArrivalDate = await handleArrivalDatePicker(
                  context: context,
                  arrivalDate: arrivalDate,
                  departureDate: departureDate);
              setArrivalDate(tempArrivalDate);
            },
            child: Text(
              arrivalDate != null
                  ? DateFormat("dd/MM/y").format(arrivalDate!)
                  : localized.setText.capitalized,
            )),
      ],
    );
  }
}