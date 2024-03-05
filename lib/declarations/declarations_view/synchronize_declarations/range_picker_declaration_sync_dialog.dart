import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/declarations/declarations_view/synchronize_declarations/date_buttons/set_arrival_date_button.dart";
import "package:decla_time/declarations/declarations_view/synchronize_declarations/date_buttons/set_departure_date_button.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class RangePickerDeclarationSyncDialog extends StatelessWidget {
  const RangePickerDeclarationSyncDialog({
    required this.localized,
    required this.arrivalDate,
    required this.departureDate,
    required this.setArrivalDate,
    required this.setDepartureDate,
    super.key,
  });

  final AppLocalizations localized;
  final DateTime? arrivalDate;
  final DateTime? departureDate;
  final void Function(DateTime?) setArrivalDate;
  final void Function(DateTime?) setDepartureDate;

  @override
  Widget build(BuildContext context) {
    return ColumnWithSpacings(
      spacing: 64,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Center(
            child: FittedBox(
              child: Text(
                localized.dateSelection.capitalized,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Flex(
          direction: MediaQuery.sizeOf(context).width < kMaxWidthSmall - 128
              ? Axis.vertical
              : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SetArrivalDateButton(
              arrivalDate: arrivalDate,
              setArrivalDate: setArrivalDate,
              departureDate: departureDate,
              localized: localized,
            ),
            SetDepartureDateButton(
              arrivalDate: arrivalDate,
              setDepartureDate: setDepartureDate,
              departureDate: departureDate,
              localized: localized,
            ),
          ],
        ),
      ],
    );
  }
}
