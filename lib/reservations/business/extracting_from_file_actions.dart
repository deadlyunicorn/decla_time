import "dart:io";

import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations/business/reservation_actions.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ExtractingReservationsFromFileActions {
  static void noReservationsAddedSnackbar(
    BuildContext context,
    AppLocalizations localized,
  ) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(localized.reservationsNotAdded.capitalized),
        ),
      ),
    );
  }

  static void reservationsAddedSnackbar(
    BuildContext context,
    AppLocalizations localized,
    int newReservationCount,
  ) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            // ignore: lines_longer_than_80_chars
            "${localized.found.capitalized} $newReservationCount ${newReservationCount > 1 ? localized.reservations : localized.reservation}.",
          ),
        ),
      ),
    );
  }

  static void reservationsNotFoundSnackbar(
    BuildContext context,
    AppLocalizations localized,
  ) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(localized.newReservationsNotFound.capitalized),
        ),
      ),
    );
  }

  ///Handles the different scenarios and
  ///returns a List of Reservation if there is any.
  static Future<Iterable<Reservation>?> handleReservationAdditionFromFiles(
    List<File> files,
    BuildContext context,
    AppLocalizations localized,
    List<Reservation> currentReservationList,
  ) async {
    final List<File> csvFiles =
        files.where((File file) => file.path.contains(".csv")).toList();
    //TODO: if we add support for xls be sure to change the above

    try {
      if (csvFiles.isNotEmpty) {
        //If files are not selected you cannot submit anyways.
        final List<Reservation> reservationsFromFile =
            await ReservationActions.generateReservationTableFromMultipleFiles(
          csvFiles,
        );

        final Iterable<Reservation> newReservationEntries =
            ReservationActions.filterReservations(
          reservationsFromFile,
          currentReservationList,
        );

        if (context.mounted) {
          if (newReservationEntries.isEmpty) {
            //No new reservations found -
            ExtractingReservationsFromFileActions.reservationsNotFoundSnackbar(
              context,
              localized,
            );
          } else {
            //Found new reservations
            final int newReservationCount = newReservationEntries.length;
            ExtractingReservationsFromFileActions.reservationsAddedSnackbar(
              context,
              localized,
              newReservationCount,
            );
            return newReservationEntries;
          }
        }
      } else if (context.mounted) {
        ExtractingReservationsFromFileActions.noReservationsAddedSnackbar(
          context,
          localized,
        );
      }
    } catch (error) {
      if (context.mounted) {
        ExtractingReservationsFromFileActions.noReservationsAddedSnackbar(
          context,
          localized,
        );
      }
    }

    return null;
  }
}
