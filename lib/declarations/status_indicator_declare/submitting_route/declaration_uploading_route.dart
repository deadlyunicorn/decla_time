import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/declarations/status_indicator_declare/declaration_submit_controller.dart";
import "package:decla_time/declarations/status_indicator_declare/submitting_route/lists/pending_reservations.dart";
import "package:decla_time/declarations/status_indicator_declare/submitting_route/lists/submitted_reservations_list.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class DeclarationUploadingRoute extends StatelessWidget {
  const DeclarationUploadingRoute({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;


  @override
  Widget build(BuildContext context) {
    final DeclarationSubmitController declarationsSubmitController =
        context.watch<DeclarationSubmitController>();

    final List<Reservation> pendingSubmissions =
        declarationsSubmitController.reservationsPendingSubmission;
    final List<ReservationSubmitResult> submitted =
        declarationsSubmitController.reservationsSubmitted;

    return RouteOutline(
      title:
          "${localized.declarationSubmit.capitalized}: ${submitted.length}/${submitted.length + pendingSubmissions.length}",
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                //TODO SinglePageScrollView
                children: <Widget>[
                  SubmittedReservationsList(
                    localized: localized,
                    submitResults: submitted,
                  ),
                  PendingReservations(
                    pendingReservations: pendingSubmissions,
                    localized: localized,
                  ),
                ],
              ),
            ),
          ),
          if (pendingSubmissions.isEmpty &&
              !submitted
                  .where(
                    (ReservationSubmitResult submitResult) =>
                        submitResult.wasSuccessful,
                  )
                  .isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  //TODO Start importing
                },
                child: Text(
                  localized.importSubmissions.capitalized,
                ),
              ),
            ), //Find earliest and latest departure date.
        ],
      ),
    );
  }
}
