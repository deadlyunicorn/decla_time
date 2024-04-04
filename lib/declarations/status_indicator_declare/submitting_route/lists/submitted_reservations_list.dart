import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/declarations/status_indicator_declare/declaration_submit_controller.dart";
import "package:decla_time/declarations/status_indicator_declare/submitting_route/lists/declaring_reservation_route_item.dart";
import "package:decla_time/declarations/status_indicator_import/declarations_import_route/declaration_import_route.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class SubmittedReservationsList extends StatelessWidget {
  const SubmittedReservationsList({
    required this.submitResults,
    required this.localized,
    super.key,
  });

  final List<ReservationSubmitResult> submitResults;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return ImportListViewOutline(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final Reservation submittedReservation =
              submitResults[index].reservation;
          final bool didFail = !submitResults[index].wasSuccessful;

          final String label = didFail
              ? localized.failed.capitalized
              : localized.wasSuccessful.capitalized;

          return ImportListTileOutline(
            child: ListTile(
              title: didFail
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(localized.failed.capitalized),
                    )
                  : DeclaringReservationRouteItem(
                      reservation: submittedReservation,
                      localized: localized,
                    ),
              trailing: Tooltip(
                message: label,
                child: didFail
                    ? Icon(
                        Icons.error,
                        color: Theme.of(context).colorScheme.error,
                        semanticLabel: label,
                      )
                    : Icon(
                        Icons.cloud_done_rounded,
                        semanticLabel: label,
                      ),
              ),
            ),
          );
        },
        itemCount: submitResults.length,
      ),
    );
  }
}
