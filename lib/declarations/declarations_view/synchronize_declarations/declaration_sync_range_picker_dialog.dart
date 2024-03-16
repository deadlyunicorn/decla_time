import "dart:async";

import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/core/widgets/custom_alert_dialog.dart";
import "package:decla_time/declarations/declarations_view/synchronize_declarations/helper_text_display.dart";
import "package:decla_time/declarations/declarations_view/synchronize_declarations/range_picker_declaration_sync_dialog.dart";
import "package:decla_time/declarations/status_indicator_import/declarations_import_route/declaration_import_controller.dart";
import "package:decla_time/declarations/utility/import_declarations_by_property_id.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/search_page_data.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
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
  SearchPageData? currentSearchPageData;
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
      confirmButtonAction: confirmActionButton,
      title: widget.localized.synchronizeDeclarations.capitalized,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          RangePickerDeclarationSyncDialog(
            localized: widget.localized,
            arrivalDate: arrivalDate,
            departureDate: departureDate,
            setArrivalDate: setArrivalDate,
            setDepartureDate: setDepartureDate,
          ),
          HelperTextDisplay(
            helperText: helperText,
            isSyncing: isSyncing,
          ),
        ],
      ),
    );
  }

  void setArrivalDate(DateTime? newArrivalDate) {
    if (arrivalDate == newArrivalDate) return;

    setState(() {
      arrivalDate = newArrivalDate;
      currentSearchPageData = null;
    });

    if (arrivalDate != null && departureDate != null) {
      getTotalDeclarationsForRange();
    }
  }

  void setDepartureDate(DateTime? newDepartureDate) {
    if (departureDate == newDepartureDate) return;

    setState(() {
      departureDate = newDepartureDate;
      currentSearchPageData = null;
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
            if (helperText.toLowerCase().contains(
                  widget.localized.synchronizing,
                )) {
              setHelperText(
                newText:
                    // ignore: lines_longer_than_80_chars
                    "${widget.localized.thisTakesLongerThanUsual.capitalized}\n${widget.localized.ifYouLostConnectionToTheInternetTryAgain.capitalized}",
              );
            }
          },
        ),
      );

      final SearchPageData searchPageData =
          await getSearchPageDetailsFromDateRangeFuture(
        arrivalDate: submitArrivalDate,
        departureDate: submitDepartureDate,
        propertyId: widget.propertyId,
        headers: headers,
      );
      setState(() {
        currentSearchPageData = searchPageData;
      });

      final int totalFound = searchPageData.total;

      if (totalFound > 0) {
        setHelperText(
          newText:
              // ignore: lines_longer_than_80_chars
              "${widget.localized.found.capitalized}: $totalFound ${totalFound > 1 ? widget.localized.declarations : widget.localized.declaration}\n${widget.localized.pressConfirmToStartImporting.capitalized}",
        );
      } else {
        setHelperText(
          newText:
              widget.localized.declarationsNotFoundForDateRange.capitalized,
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
    } on NotLoggedInException {
      if (mounted) {
        final LoggedUser loggedUser =
            context.read<UsersController>().loggedUser;
        final UserCredentials? userCredentials = loggedUser.userCredentials;
        if (userCredentials == null) {
          context.read<UsersController>().setRequestLogin(true);
          Navigator.of(context).pop();
          return;
        }
        loggedUser.setDeclarationsPageHeaders(
          await loginUser(credentials: userCredentials),
        );
        await getTotalDeclarationsForRange();
      }
    } on TryAgainLaterException {
      setHelperText(
        newText: widget.localized.tryAgainLater.capitalized,
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

  Future<void> confirmActionButton() async {
    final SearchPageData? tempCurrentSearchPageData = currentSearchPageData;
    final DateTime? departureDateTemp = departureDate;
    final DateTime? arrivalDateTemp = arrivalDate;

    if (isSyncing == true) {
      setHelperText(
        newText:
            // ignore: lines_longer_than_80_chars
            "${widget.localized.synchronizing.capitalized}...\n${widget.localized.pleaseWait.capitalized}",
      );
    } else if (tempCurrentSearchPageData == null ||
        tempCurrentSearchPageData.total == 0 ||
        departureDateTemp == null ||
        arrivalDateTemp == null) {
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

      final DeclarationsPageHeaders initialHeaders =
          context.read<UsersController>().loggedUser.headers!;
      final UserCredentials? credentials =
          context.read<UsersController>().loggedUser.userCredentials;

      void updateHeaders(DeclarationsPageHeaders newHeaders) => context
          .read<UsersController>()
          .loggedUser
          .setDeclarationsPageHeaders(newHeaders);

      Future<void> startImporting(DeclarationsPageHeaders headers) => context
          .read<DeclarationImportController>()
          .startImportingDeclarations(
            arrivalDate: arrivalDateTemp,
            departureDate: departureDateTemp,
            propertyId: widget.propertyId,
            headers: headers,
          );

      try {
        unawaited(startImporting(initialHeaders));
      } on NotLoggedInException {
        //* UNTESTED CODE.
        unawaited(
          loginUser(credentials: credentials!).then(
            (DeclarationsPageHeaders newHeaders) {
              updateHeaders(newHeaders);
              startImporting(newHeaders);
            },
          ),
        );
      }

      Navigator.popUntil(context, (Route<void> route) {
        return route.isFirst;
      });
    }
  }
}
