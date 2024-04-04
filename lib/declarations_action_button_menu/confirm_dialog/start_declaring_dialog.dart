import "dart:async";

import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/custom_alert_dialog.dart";
import "package:decla_time/declarations/functions/check_if_logged_in.dart";
import "package:decla_time/declarations/status_indicator_declare/declaration_submit_controller.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:http/http.dart" as http;
import "package:provider/provider.dart";

class StartDeclaringDialog extends StatefulWidget {
  const StartDeclaringDialog({
    required this.localized,
    required this.reservationToBeSubmitted,
    required this.propertyId,
    super.key,
  });

  final AppLocalizations localized;
  final List<Reservation> reservationToBeSubmitted;
  final String propertyId;

  @override
  State<StartDeclaringDialog> createState() => _StartDeclaringDialogState();
}

class _StartDeclaringDialogState extends State<StartDeclaringDialog> {
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      confirmButtonAction: () async {
        final IsarHelper isarHelper = context.read<IsarHelper>();

        try {
          if (context.read<DeclarationSubmitController>().isSubmitting) {
            throw AlreadySubmittingDeclarations();
          }

          final DeclarationsPageHeaders? headers =
              context.read<UsersController>().loggedUser.headers;

          if (headers == null) {
            throw NotLoggedInException();
          }

          await http
              .get(
            Uri.parse("https://www1.aade.gr/taxisnet/short_term_letting"),
            headers: headers.getHeadersForGET(),
          )
              .then(
            (http.Response res) {
              checkIfLoggedIn(res.body);
            },
          ).then(
            (_) {
              unawaited(
                context.read<DeclarationSubmitController>().startSubmitting(
                      reservations: widget.reservationToBeSubmitted,
                      headers: headers,
                      propertyId: widget.propertyId,
                      putReservationToDb: isarHelper
                          .reservationActions.insertMultipleEntriesToDb,
                    ),
              );
            },
          );

          if (context.mounted) {
            Navigator.popUntil(context, (Route<void> route) {
              return route.isFirst;
            });
          }
        } on AlreadySubmittingDeclarations {
          setState(() {
            errorMessage =
                widget.localized.alreadySubmittingDeclarations.capitalized;
          });
        } on NotLoggedInException {
          //* UNTESTED CODE.
          if (context.mounted) {
            final UserCredentials? credentials =
                context.read<UsersController>().loggedUser.userCredentials;
            if (credentials != null) {
              await loginUser(credentials: credentials).then(
                (DeclarationsPageHeaders newHeaders) {
                  context
                      .read<UsersController>()
                      .loggedUser
                      .setDeclarationsPageHeaders(newHeaders);
                },
              );
              setState(() {
                errorMessage =
                    widget.localized.sessionErrorTryAgainOrRestartTheApp;
              });
            } else {
              setState(() {
                errorMessage = widget.localized.notLoggedIn.capitalized;
              });
            }
          }
        } on TryAgainLaterException {
          setState(() {
            errorMessage = widget.localized.tryAgainLater.capitalized;
          });
        }
      },
      title: widget.localized.confirmDeclarationSubmit.capitalized,
      localized: widget.localized,
      child: ColumnWithSpacings(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.localized.youAreAboutToStartSubmitting,
            textAlign: TextAlign.center,
          ),
          Text(
            // ignore: lines_longer_than_80_chars
            "${widget.localized.youHaveSelected.capitalized} ${widget.reservationToBeSubmitted.length} ${(widget.reservationToBeSubmitted.length == 1) ? widget.localized.reservation : widget.localized.reservations}",
          ),
          if (errorMessage != null)
            Text(
              errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
