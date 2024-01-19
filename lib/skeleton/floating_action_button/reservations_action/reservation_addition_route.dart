import 'dart:math';

import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/skeleton/floating_action_button/reservations_action/import_from_files_button.dart';
import 'package:decla_time/skeleton/floating_action_button/reservations_action/reservation_addition_button.dart';
import 'package:decla_time/skeleton/floating_action_button/reservations_action/reservations_found_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
                ReservationAdditionButton(
                  description: "Manual Entry",
                  icon: Icons.edit,
                  onTap: () {
                    print("no way");
                  },
                ),
              ],
            ),
            Text(
              "Basically below the inserted entries will appear and the user will be able to select them.",
            ),
            ReservationsFoundList(reservations: reservations),
          ],
        ),
      ),
    );
  }

  void addToReservationsFoundSoFar(newReservationEntries) {
                  setState(() {
                    reservations.addAll(newReservationEntries);
                  });
                }
}
