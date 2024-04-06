import "dart:io";

import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/is_landscape_mode.dart";
import "package:decla_time/core/widgets/item_select/generic_item_select_grid.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/reservations/business/extracting_from_file_actions.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:decla_time/reservations_action_button_menu/add_from_files_button.dart";
import "package:decla_time/reservations_action_button_menu/add_reservations_manually_button.dart";
import "package:decla_time/reservations_action_button_menu/entries_found/reservation_details_tooltip.dart";
import "package:decla_time/reservations_action_button_menu/entries_found/selectable_reservation_container.dart";
import "package:decla_time/reservations_action_button_menu/entries_found/will_overwrite_tooltip.dart";
import "package:decla_time/reservations_action_button_menu/selected_reservations_handler.dart";
import "package:desktop_drop/desktop_drop.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ReservationAdditionRoute extends StatefulWidget {
  const ReservationAdditionRoute({
    required this.localized,
    super.key,
  });
  final AppLocalizations localized;

  @override
  State<ReservationAdditionRoute> createState() =>
      _ReservationAdditionRouteState();
}

class _ReservationAdditionRouteState extends State<ReservationAdditionRoute> {
  List<Reservation> reservations = <Reservation>[];

  @override
  Widget build(BuildContext context) {
    return RouteOutline(
      title: widget.localized.importReservations.capitalized,
      child: DropTarget(
        onDragDone: (DropDoneDetails details) async {
          final List<File> files =
              // ignore: always_specify_types
              details.files.map((xFile) => File(xFile.path)).toList();
          final Iterable<Reservation> newReservations =
              await ExtractingReservationsFromFileActions
                      .handleReservationAdditionFromFiles(
                    files,
                    context,
                    widget.localized,
                    reservations,
                  ) ??
                  <Reservation>[];
          if (newReservations.isNotEmpty) {
            setState(() {
              reservations.addAll(newReservations);
            });
          }
        },
        child: Flex(
          direction: isLandscapeMode(context) ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
                    children: <Widget>[
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
              child: ItemsFoundList<Reservation>(
                items: reservations,
                localized: widget.localized,
                child: ({
                  required bool isSelected,
                  required Reservation item,
                  required AppLocalizations localized,
                }) =>
                    SelectableReservationContainer(
                  localized: localized,
                  reservation: item,
                  isSelected: isSelected,
                ),
                positionedChildren: ({
                  required AppLocalizations localized,
                  required Reservation item,
                }) =>
                    <Widget>[
                  ReservationDetailsTooltip(
                    reservation: item,
                    localized: widget.localized,
                  ),
                  WillOverwriteTooltip(
                    reservation: item,
                    localized: widget.localized,
                  ),
                ],
                selectedItemsHandler: ({
                  required Set<int> setOfIndicesOfSelectedItems,
                }) =>
                    SelectedReservationsHandler(
                  localized: widget.localized,
                  removeFromReservationsFoundSoFar:
                      removeFromReservationsFoundSoFar,
                  reservations: reservations,
                  setOfIndicesOfSelectedItems: setOfIndicesOfSelectedItems,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToReservationsFoundSoFar(
    Iterable<Reservation> newReservationEntries,
  ) {
    setState(() {
      reservations.addAll(newReservationEntries);
    });
  }

  void removeFromReservationsFoundSoFar(
    Iterable<Reservation> iterableReservations,
  ) {
    setState(() {
      reservations.removeWhere(
        (Reservation reservation) => iterableReservations
            .map((Reservation e) => e.id)
            .contains(reservation.id),
      );
    });
  }
}
