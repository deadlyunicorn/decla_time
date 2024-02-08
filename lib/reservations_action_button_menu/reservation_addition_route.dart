import 'dart:io';
import 'package:decla_time/core/functions/is_landscape_mode.dart';
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
    required this.localized,
  });
  final AppLocalizations localized;

  @override
  State<ReservationAdditionRoute> createState() =>
      _ReservationAdditionRouteState();
}

class _ReservationAdditionRouteState extends State<ReservationAdditionRoute> {
  List<Reservation> reservations = [];

  @override
  Widget build(BuildContext context) {
    return RouteOutline(
      title: widget.localized.addEntries,
      child: DropTarget(
        onDragDone: (details) async {
          final files = details.files.map((xFile) => File(xFile.path)).toList();
          final newReservations = await ExtractingReservationsFromFileActions
                  .handleReservationAdditionFromFiles(
                      files, context, widget.localized, reservations) ??
              [];
          if (newReservations.isNotEmpty) {
            setState(() {
              reservations.addAll(newReservations);
            });
          }
        },
        child: Flex(
          direction: isLandscapeMode(context) ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: isLandscapeMode(context)
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
                        localized: widget.localized,
                      ),
                      AddReservationsManuallyButton(
                        localized: widget.localized,
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
                localized: widget.localized,
              ),
            ),
          ],
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
