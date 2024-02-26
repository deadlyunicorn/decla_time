import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/custom_alert_dialog.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/synchronize_declarations/date_buttons/set_arrival_date_button.dart";
import "package:decla_time/declarations/synchronize_declarations/date_buttons/set_departure_date_button.dart";
import "package:decla_time/declarations/utility/import_declarations_by_property_id.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class DeclarationSyncRangePickerDialog extends StatefulWidget {
  const DeclarationSyncRangePickerDialog({
    required this.localized,
    required this.propertyId,
    required this.parentContext,
    super.key,
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
        final DeclarationsPageHeaders? headers =
            context.read<UsersController>().loggedUser.headers;
        if (headers == null) {
          setHelperText(context: context, newText: "Not logged in");
          context.read<UsersController>().setRequestLogin(true);
          return;
        }
        setHelperText(
          context: context,
          newText: "${widget.localized.synchronizing.capitalized}...",
        );

        final DateTime? submitArrivalDate = arrivalDate;
        final DateTime? submitDepartureDate = departureDate;

        if (submitArrivalDate == null) {
          setHelperText(context: context, newText: "No arrival date");
          return;
        } else if (submitDepartureDate == null) {
          setHelperText(context: context, newText: "No departure date");
          return;
        }

        int totalNew = 0;

        try {
          await importDeclarationsFromDateRangeFuture(
            arrivalDate: submitArrivalDate,
            departureDate: submitDepartureDate,
            propertyId: widget.propertyId,
            headers: headers,
            displayTotalFound: (int totalFound) {
              setHelperText(
                context: context,
                newText: "Total found: $totalFound",
              );
            },
            displayCurrentStatus: ({
              required int index,
              required int total,
              required bool existsInDb,
            }) {
              setHelperText(
                context: context,
                newText: "Is new: ${!existsInDb}\n${index + 1} / $total",
              );
            },
            checkIfDeclarationExistsInDb:
                (SearchPageDeclaration searchPageDeclaration) async {
              const bool exists = false;
              if (!exists) totalNew++;
              return exists;
            },
            storeDeclarationInDb: (Declaration declaration) async {
              print("storing in db");
            },
          );
          if (totalNew > 0) {
            setHelperText(
              // ignore: use_build_context_synchronously
              context: context,
              newText: "imported $totalNew new declarations",
            );
          } else {
            setHelperText(
              newText: "no new declarations found.",
              // ignore: use_build_context_synchronously
              context: context,
            );
          }

          print("haha");
        } catch (error) {
          //TODO
          setHelperText(
            newText: "Handle errors here... Maybe add some error text..",
            context: context,
          );
        }

        // setHelperText("");

        //? After we synchronized successfully.
        //? ( dont close on erros e.g. network)
        // Navigator.popUntil(context, (route) {
        //   return route.isFirst;
        // });
      },
      title: "Synchronize things",
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          ColumnWithSpacings(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Center(
                child: FittedBox(
                  child: Text(
                    "Επιλογή ημερομηνίων",
                    //? Next commit:widget.localized.dateSelection.capitalized,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Flex(
                direction:
                    MediaQuery.sizeOf(context).width < kMaxWidthSmall - 128
                        ? Axis.vertical
                        : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
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
                  ),
                ],
              ),
            ],
          ),
          Positioned.fill(
            bottom: -128,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                helperText,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setArrivalDate(DateTime? newArrivalDate) {
    if (arrivalDate == newArrivalDate) return;

    setState(() {
      arrivalDate = newArrivalDate;
    });
  }

  void setDepartureDate(DateTime? newDepartureDate) {
    if (departureDate == newDepartureDate) return;

    setState(() {
      departureDate = newDepartureDate;
    });
  }

  void setHelperText({required String newText, required BuildContext context}) {
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
