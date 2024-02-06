import 'dart:io';

import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/business/reservation_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:decla_time/core/extensions/capitalize.dart';

class ExtractingReservationsFromFileActions {
  static void noReservationsAddedSnackbar(
      BuildContext context, AppLocalizations localized) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(localized.reservationsNotAdded.capitalized),
        ),
      ),
    );
  }

  static void reservationsAddedSnackbar(BuildContext context,
      AppLocalizations localized, int newReservationCount) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            "${localized.found.capitalized} $newReservationCount ${newReservationCount > 1 ? localized.reservations : localized.reservation}.",
          ),
        ),
      ),
    );
  }

  static void reservationsNotFoundSnackbar(
      BuildContext context, AppLocalizations localized) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(localized.newReservationsNotFound.capitalized),
        ),
      ),
    );
  }

  ///Handles the different scenarios and returns a List of Reservation if there is any.
  static Future<Iterable<Reservation>?> handleReservationAdditionFromFiles(
    List<File> files,
    BuildContext context,
    AppLocalizations localized,
    List<Reservation> currentReservationList,
  ) async {
    try {
      if (files.isNotEmpty) {
        //If files are not selected you cannot submit anyways.
        final reservationsFromFile =
            await ReservationActions.generateReservationTableFromMultipleFiles(
          files,
        );

        final newReservationEntries = ReservationActions.filterReservations(
          reservationsFromFile,
          currentReservationList,
        );

        if (context.mounted) {
          if (newReservationEntries.isEmpty) {
            //No new reservations found -
            ExtractingReservationsFromFileActions.reservationsNotFoundSnackbar(
                context, localized);
          } else {
            //Found new reservations
            final newReservationCount = newReservationEntries.length;
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
