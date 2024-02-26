import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/handle_range_date_pickers.dart";
import "package:decla_time/declarations/declarations_view/synchronize_declarations/date_buttons/date_buttons_outline.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:intl/intl.dart";

class SetArrivalDateButton extends StatelessWidget {
  const SetArrivalDateButton({
    required this.arrivalDate,
    required this.departureDate,
    required this.localized,
    required this.setArrivalDate,
    super.key,
  });

  final DateTime? arrivalDate;
  final DateTime? departureDate;
  final AppLocalizations localized;
  final void Function(DateTime?) setArrivalDate;

  @override
  Widget build(BuildContext context) {
    return DateButtonsOutline(
      children: <Widget>[
        Text("${localized.arrival.capitalized}: "),
        TextButton(
          onPressed: () async {
            final DateTime? tempArrivalDate = await handleArrivalDatePicker(
              context: context,
              arrivalDate: arrivalDate,
              departureDate: departureDate,
            );
            setArrivalDate(tempArrivalDate);
          },
          child: Text(
            arrivalDate != null
                ? DateFormat("dd/MM/y").format(arrivalDate!)
                : localized.setText.capitalized,
          ),
        ),
      ],
    );
  }
}
