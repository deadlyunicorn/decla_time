import 'dart:io';
import 'dart:math';

import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/night_or_nights.dart';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/extracting_from_file_actions.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations_action_button_menu/import_from_files_button.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/manual_reservation_entry_route.dart';
import 'package:decla_time/reservations_action_button_menu/import_manually_button.dart';
import 'package:decla_time/reservations_action_button_menu/entries_found/reservations_found_list.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationAdditionRoute extends StatefulWidget {
  const ReservationAdditionRoute({
    super.key,
  });

  @override
  State<ReservationAdditionRoute> createState() =>
      _ReservationAdditionRouteState();
}

class _ReservationAdditionRouteState extends State<ReservationAdditionRoute> {
  List<Reservation> reservations = [];

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return RouteOutline(
      title: localized.addEntries,
      child: DropTarget(
        onDragDone: (details) async {
          final files = details.files.map((xFile) => File(xFile.path)).toList();
          final newReservations = await ExtractingReservationsFromFileActions
                  .handleReservationAdditionFromFiles(
                      files, context, localized, reservations) ??
              [];
          if (newReservations.isNotEmpty) {
            setState(() {
              reservations.addAll(newReservations);
            });
          }
        },
        child: SizedBox(
          width: min(MediaQuery.sizeOf(context).width, 900),
          child: Column(
            children: [
              const SizedBox.square(
                dimension: 32,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 32,
                runSpacing: 32,
                children: [
                  ImportFromFilesButton(
                    reservationsAlreadyImported: reservations,
                    addToReservationsFoundSoFar: addToReservationsFoundSoFar,
                  ),
                  ReservationAdditionButtonOutline(
                    description: localized.manualAddition.capitalized,
                    icon: Icons.edit,
                    onTap: () async {
                      final reservation = await Navigator.push<Reservation?>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManualReservationEntryRoute(
                            addToReservationsFoundSoFar:
                                addToReservationsFoundSoFar,
                          ),
                        ),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  
                        if (reservation != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                child: Text(
                                  "${localized.addedAReservation.capitalized}.\n${localized.reservationLasted.capitalized} ${nightOrNights(localized, reservation.nights)}.\n${localized.thePayoutIs.capitalized} ${reservation.payout}€.",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                child: Text(
                                    localized.reservationsNotAdded.capitalized),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: ReservationsFoundList(
                  reservations: reservations,
                  removeFromReservationsFoundSoFar:
                      removeFromReservationsFoundSoFar,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addToReservationsFoundSoFar(
      Iterable<Reservation> newReservationEntries) {
    setState(() {
      reservations.addAll(newReservationEntries);
    });
  }

  void removeFromReservationsFoundSoFar(
      Iterable<Reservation> iterableReservations) {
    setState(() {
      reservations.removeWhere(
        (reservation) =>
            iterableReservations.map((e) => e.id).contains(reservation.id),
      );
    });
  }
}
