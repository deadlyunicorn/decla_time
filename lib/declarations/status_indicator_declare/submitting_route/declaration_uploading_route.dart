import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/declarations/declarations_view/synchronize_declarations/declaration_sync_range_picker_dialog.dart";
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
      onExit: () {
        if (pendingSubmissions.isEmpty) {
          declarationsSubmitController.clearSubmitted();
        }
      },
      title: pendingSubmissions.isEmpty && submitted.isEmpty
          ? localized.noPendingOperations.capitalized
          : "${localized.declarationSubmit.capitalized}: ${submitted.length}/${submitted.length + pendingSubmissions.length}",
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
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
              submitted
                  .where(
                    (ReservationSubmitResult submitResult) =>
                        submitResult.wasSuccessful,
                  )
                  .isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ColumnWithSpacings(
                spacing: 4,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      declarationsSubmitController.clearSubmitted();
                    },
                    child: Text(
                      localized.clear.capitalized,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  ImportSubmittedDeclarations(
                    localized: localized,
                  ),
                ],
              ),
            ), //Find earliest and latest departure date.
        ],
      ),
    );
  }
}

class ImportSubmittedDeclarations extends StatelessWidget {
  const ImportSubmittedDeclarations({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final DeclarationSubmitController declarationsSubmitController =
        context.watch<DeclarationSubmitController>();
    final List<ReservationSubmitResult> submitted =
        declarationsSubmitController.reservationsSubmitted;

    return TextButton(
      onPressed: () {
        final String? lastSubmittingPropertyId =
            declarationsSubmitController.lastSubmittingPropertyId;
        if (lastSubmittingPropertyId != null &&
            lastSubmittingPropertyId.isNotEmpty) {
          final List<ReservationSubmitResult>
              declarationsToImportOrderedByDate = submitted
                  .where(
                    (ReservationSubmitResult declaration) =>
                        declaration.wasSuccessful,
                  )
                  .toList()
                ..sort(
                  (
                    ReservationSubmitResult a,
                    ReservationSubmitResult b,
                  ) =>
                      a.reservation.departureDate.compareTo(
                    b.reservation.departureDate,
                  ),
                );

          final DateTime earliest = declarationsToImportOrderedByDate
              .first.reservation.departureDate
              .subtract(const Duration(days: 1));
          final DateTime latest = declarationsToImportOrderedByDate
              .last.reservation.departureDate
              .add(const Duration(days: 1));

          startImportingDeclarations(
            context: context,
            arrivalDate: earliest,
            departureDateDate: latest,
            propertyId: lastSubmittingPropertyId,
          );

          declarationsSubmitController.clearSubmitted();
        }
      },
      child: Text(
        localized.importSubmissions.capitalized,
      ),
    );
  }
}
