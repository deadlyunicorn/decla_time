import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/snackbars.dart';
import 'package:decla_time/core/widgets/custom_alert_dialog.dart';
import 'package:decla_time/declarations/synchronize_declarations/set_arrival_date_button.dart';
import 'package:decla_time/declarations/synchronize_declarations/set_departure_date_button.dart';
import 'package:decla_time/declarations/utility/import_declarations_by_property_id.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DeclarationSyncRangePickerDialog extends StatefulWidget {
  const DeclarationSyncRangePickerDialog({
    super.key,
    required this.localized,
    required this.propertyId,
    required this.parentContext,
  });

  final AppLocalizations localized;
  final String propertyId;
  final BuildContext parentContext;

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
        final headers = context.read<UsersController>().loggedUser.headers;
        if (headers == null) {
          setHelperText(context: context, newText: "Not logged in");
          context.read<UsersController>().setRequestLogin(true);
          return;
        }
        setHelperText(
            context: context,
            newText: "${widget.localized.synchronizing.capitalized}...");

        final submitArrivalDate = arrivalDate;
        final submitDepartureDate = departureDate;

        if (submitArrivalDate == null) {
          setHelperText(context: context, newText: "No arrival date");
          return;
        } else if (submitDepartureDate == null) {
          setHelperText(context: context, newText: "No departure date");
          return;
        }

        int totalNew = 0;
        
        try{

        await importDeclarationsFromDateRangeFuture(
          arrivalDate: submitArrivalDate,
          departureDate: submitDepartureDate,
          propertyId: widget.propertyId,
          headers: headers,
          displayTotalFound: (totalFound) {
            setHelperText(
                context: context, newText: "Total found: $totalFound");
          },
          displayCurrentStatus: (
              {required index, required total, required existsInDb}) {
            setHelperText(
                context: context,
                newText: "Is new: ${!existsInDb}\n${index + 1} / $total");
          },
          checkIfDeclarationExistsInDb: (searchPageDeclaration) async {
            final bool exists = false;
            if (!exists) totalNew++;
            return exists;
          },
          storeDeclarationInDb: (declaration) async {
            print("storing in db");
          },
        );
        if (totalNew > 0) {
          // ignore: use_build_context_synchronously
          setHelperText(
              context: context, newText: "imported $totalNew new declarations");
        } else {
          // ignore: use_build_context_synchronously
          setHelperText(
              newText: "no new declarations found.", context: context);
        }

        print("haha");
        } catch( error ){
          //TODO
          setHelperText(newText: "Handle errors here... Maybe add some error text..", context: context);
        }

        // setHelperText("");

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
                  "Επιλογή ημερομηνίων",//? Next commit:widget.localized.dateSelection.capitalized,
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
                alignment: Alignment.bottomCenter,
                child: Text(
                  helperText,
                  textAlign: TextAlign.center,
                )),
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

  setHelperText({required String newText, required BuildContext context}) {
    if (newText != helperText && context.mounted) {
      setState(() {
        helperText = newText;
      });
    } else if (widget.parentContext.mounted) {
      showNormalSnackbar(
        context: widget.parentContext,
        message: newText,
        textAlign: TextAlign.center,
      );
    }
  }
}
