import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/declarations/status_indicator_import/declarations_import_route/declaration_import_route.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class PendingReservations extends StatelessWidget {
  const PendingReservations({
    required this.pendingReservations,
    required this.localized,
    super.key,
  });

  final List<Reservation> pendingReservations;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return ImportListViewOutline(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final Reservation pendingReservation = pendingReservations[index];

          return ImportListTileOutline(
            child: ListTile(
              trailing: const CircularProgressIndicator(),
              title: DeclarationToBeImportedDetails(
                pendingReservation: pendingReservation,
                localized: localized,
              ),
            ),
          );
        },
        itemCount: pendingReservations.length,
      ),
    );
  }
}

class DeclarationToBeImportedDetails extends StatelessWidget {
  const DeclarationToBeImportedDetails({
    required this.pendingReservation,
    required this.localized,
    super.key,
  });

  final Reservation pendingReservation;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    bool isBigScreen = MediaQuery.sizeOf(context).width > kMaxWidthSmall;

    return Column(
      children: <Widget>[
        FittedBox(
          child: Text(
            // ignore: lines_longer_than_80_chars
            "${pendingReservation.arrivalDateString} - ${pendingReservation.departureDateString}",
          ),
        ),
        Flex(
          direction: isBigScreen ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
              child: Text(
                "${pendingReservation.payout.toStringAsFixed(2)} EUR",
              ),
            ),
            if (isBigScreen) const Text(" - "),
            FittedBox(
              child: Text(
                "hlelo"
                //TODO Improvise
              ),
            ),
          ],
        ),
      ],
    );
  }
}
