import 'dart:math';

import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations_action_button_menu/import_from_files_button.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/manual_reservation_entry_route.dart';
import 'package:decla_time/reservations_action_button_menu/import_manually_button.dart';
import 'package:decla_time/reservations_action_button_menu/entries_found/reservations_found_list.dart';
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
      child: SizedBox(
        width: min(MediaQuery.sizeOf(context).width, 900),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 32,
              runSpacing: 32,
              children: [
                ImportFromFilesButton(
                  reservationsFoundSoFar: reservations,
                  addToReservationsFoundSoFar: addToReservationsFoundSoFar,
                ),
                ImportManuallyButton(
                  description: "Manual Entry",
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManualReservationEntryRoute(
                              addToReservationsFoundSoFar:
                                  addToReservationsFoundSoFar),
                        ));
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child:
                              Text(localized.reservationsNotAdded.capitalized),
                        ),
                      ),
                    );
                    print("no way");
                  },
                ),
              ],
            ),
            Expanded(
              child: ReservationsFoundList(reservations: reservations),
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
}
