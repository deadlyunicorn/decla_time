import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/handle_range_date_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SetDepartureDateButton extends StatelessWidget {
  const SetDepartureDateButton({
    super.key,
    required this.arrivalDate,
    required this.departureDate,
    required this.localized,
    required this.setDepartureDate,
  });

  final DateTime? arrivalDate;
  final DateTime? departureDate;
  final AppLocalizations localized;
  final void Function(DateTime?) setDepartureDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${localized.departure.capitalized}: "),
        TextButton(
            onPressed: () async {
              final tempDepartureDate = await handleDepartureDatePicker(
                context: context,
                arrivalDate: arrivalDate,
                departureDate: departureDate,
              );
              setDepartureDate(tempDepartureDate);
            },
            child: Text(
              departureDate != null
                  ? DateFormat("dd/MM/y").format(departureDate!)
                  : localized.setText.capitalized,
            )),
      ],
    );
  }
}
