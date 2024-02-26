import "dart:async";

import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/custom_alert_dialog.dart";
import "package:decla_time/declarations/declarations_view/synchronize_declarations/date_buttons/set_arrival_date_button.dart";
import "package:decla_time/declarations/declarations_view/synchronize_declarations/date_buttons/set_departure_date_button.dart";
import "package:decla_time/declarations/utility/import_declarations_by_property_id.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/search_page_data.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:http/http.dart";
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
  int totalDeclarationsFound = 0;
  DateTime? arrivalDate;
  DateTime? departureDate;
  bool isSyncing = false;
  String helperText = "";

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      mouseCursor: isSyncing
          ? SystemMouseCursors.wait
          : (arrivalDate == null || departureDate == null)
              ? SystemMouseCursors.forbidden
              : null,
      localized: widget.localized,
      confirmButtonAction: () async {
        if (isSyncing == true) {
          setHelperText(
            newText:
                // ignore: lines_longer_than_80_chars
                "${widget.localized.synchronizing.capitalized}...\n${widget.localized.pleaseWait.capitalized}",
          );
        } else if (totalDeclarationsFound == 0) {
          setHelperText(
            newText:
                // ignore: lines_longer_than_80_chars
                "${widget.localized.noDeclarationsFound.capitalized}\n${widget.localized.trySelectingAnotherDateRange}",
          );
        } else {
          //? Search Page date range is already -
          //? The only issue would be if the user went AFK
          //? and pressed confirm afterwards.
          //?( But then they might get a logged out session? )

          Navigator.popUntil(context, (Route<void> route) {
            return route.isFirst;
          });
        }
      },
      title: widget.localized.synchronizeDeclarations.capitalized,
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
                    widget.localized.dateSelection.capitalized,
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
            bottom: -128 - 64,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Text(
                    helperText,
                    textAlign: TextAlign.center,
                  ),
                  if (isSyncing)
                    const Positioned(
                      bottom: -64,
                      child: CircularProgressIndicator(),
                    ),
                ],
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
      totalDeclarationsFound = 0;
    });

    if (arrivalDate != null && departureDate != null) {
      getTotalDeclarationsForRange();
    }
  }

  void setDepartureDate(DateTime? newDepartureDate) {
    if (departureDate == newDepartureDate) return;

    setState(() {
      departureDate = newDepartureDate;
      totalDeclarationsFound = 0;
    });

    if (arrivalDate != null && departureDate != null) {
      getTotalDeclarationsForRange();
    }
  }

  void setHelperText({required String newText}) {
    if (newText != helperText && mounted) {
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

  Future<void> getTotalDeclarationsForRange() async {
    final DeclarationsPageHeaders? headers =
        context.read<UsersController>().loggedUser.headers;

    if (headers == null) {
      context.read<UsersController>().setRequestLogin(true);
      Navigator.of(context).pop();
      return;
    }

    final DateTime? submitArrivalDate = arrivalDate;
    final DateTime? submitDepartureDate = departureDate;

    try {
      if (submitArrivalDate == null) {
        throw NoArrivalDateExcepetion();
      } else if (submitDepartureDate == null) {
        throw NoDepartureDateExcepetion();
      }

      setState(() {
        isSyncing = true;
      });
      setHelperText(
        newText: "${widget.localized.synchronizing.capitalized}...",
      );
      unawaited(
        Future<void>.delayed(const Duration(seconds: 45)).then(
          (_) {
            setHelperText(
              newText:
                  // ignore: lines_longer_than_80_chars
                  "${widget.localized.thisTakesLongerThanUsual.capitalized}\n${widget.localized.ifYouLostConnectionToTheInternetTryAgain.capitalized}",
            );
          },
        ),
      );
      final int tempDeclarationsFound =
          await getSearchPageDetailsFromDateRangeFuture(
        arrivalDate: submitArrivalDate,
        departureDate: submitDepartureDate,
        propertyId: widget.propertyId,
        headers: headers,
      ).then(
        (SearchPageData searchPageDetails) => searchPageDetails.total,
      );

      setState(() {
        totalDeclarationsFound = tempDeclarationsFound;
      });

      if (totalDeclarationsFound > 0) {
        setHelperText(
          newText:
              // ignore: lines_longer_than_80_chars
              "${widget.localized.found.capitalized}: $totalDeclarationsFound ${totalDeclarationsFound > 1 ? widget.localized.declarations : widget.localized.declaration}\n${widget.localized.pressConfirmToStartImporting.capitalized}",
        );
      } else {
        setHelperText(
          newText: "no new declarations found.",
        );
      }
    } on NoArrivalDateExcepetion {
      if (mounted) {
        setHelperText(
          newText: widget.localized.noArrivalDateSet.capitalized,
        );
      }
    } on NoDepartureDateExcepetion {
      if (mounted) {
        setHelperText(
          newText: widget.localized.noDepartureDateSet.capitalized,
        );
      }
    } on ClientException {
      setHelperText(
        newText: widget.localized.errorNoConnection.capitalized,
      );
    } catch (error) {
      if (mounted) {
        setHelperText(
          newText: widget.localized.errorUnknown.capitalized,
        );
      }
    }
    setState(() {
      isSyncing = false;
    });
  }
}

//TODO FOR LATER USER
/*
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

*/
