import 'dart:io';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/extracting_from_file_actions.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations_action_button_menu/add_reservations_manually_button.dart';
import 'package:decla_time/reservations_action_button_menu/add_from_files_button.dart';
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
        child: Flex(
          direction: isLandscapeMode ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: isLandscapeMode
                  ? MediaQuery.sizeOf(context).width / 3
                  : MediaQuery.sizeOf(context).width,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    spacing: 32,
                    runSpacing: 32,
                    children: [
                      AddReservationsFromFileButton(
                        reservationsAlreadyImported: reservations,
                        addToReservationsFoundSoFar:
                            addToReservationsFoundSoFar,
                      ),
                      AddReservationsManuallyButton(
                        localized: localized,
                        addToReservationsFoundSoFar:
                            addToReservationsFoundSoFar,
                      ),
                    ],
                  ),
                ),
              ),
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
    );
  }

  bool get isLandscapeMode => MediaQuery.sizeOf(context).height < 640;

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
