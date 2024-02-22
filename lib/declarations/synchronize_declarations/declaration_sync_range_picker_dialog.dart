import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/widgets/custom_alert_dialog.dart';
import 'package:decla_time/declarations/synchronize_declarations/set_arrival_date_button.dart';
import 'package:decla_time/declarations/synchronize_declarations/set_departure_date_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeclarationSyncRangePickerDialog extends StatefulWidget {
  const DeclarationSyncRangePickerDialog({
    super.key,
    required this.localized,
  });

  final AppLocalizations localized;

  @override
  State<DeclarationSyncRangePickerDialog> createState() =>
      _DeclarationSyncRangePickerDialogState();
}

class _DeclarationSyncRangePickerDialogState
    extends State<DeclarationSyncRangePickerDialog> {
  DateTime? arrivalDate;
  DateTime? departureDate;
  String helperText = "";

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      localized: widget.localized,
      confirmButtonAction: () async {
        setState(() {
          helperText = "Έναρξη συγχρονισμού..";
        });

        await 

        await Future.delayed(Duration(seconds: 1));
        setState(() {
          helperText = "";
        });
        //? After we synchronized successfully. ( dont close on erros e.g. network)
        // Navigator.popUntil(context, (route) {
        //   return route.isFirst;
        // });
      },
      title: "Synchronize things",
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: kMenuHeight * 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Επιλογή ημερομηνίων",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SetArrivalDateButton(
                      arrivalDate: arrivalDate,
                      setArrivalDate: setArrivalDate,
                      departureDate: departureDate,
                      localized: widget.localized,
                    ),
                    SetDepartureDateButton(
                      arrivalDate: arrivalDate,
                      setDepartureDate: setDepartureDate,
                      departureDate: departureDate,
                      localized: widget.localized,
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            bottom: -128,
            child: Align(
                alignment: Alignment.bottomCenter, child: Text(helperText)),
          )
        ],
      ),
    );
  }

  setArrivalDate(DateTime? newArrivalDate) {
    if (arrivalDate == newArrivalDate) return;

    setState(() {
      arrivalDate = newArrivalDate;
    });
  }

  setDepartureDate(DateTime? newDepartureDate) {
    if (departureDate == newDepartureDate) return;

    setState(() {
      departureDate = newDepartureDate;
    });
  }
}
