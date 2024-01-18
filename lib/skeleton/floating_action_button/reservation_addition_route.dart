import 'dart:math';

import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/skeleton/floating_action_button/import_from_files_button.dart';
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
                ImportFromFiles(
                  reservationsFoundSoFar: reservations,
                  addToReservationsFoundSoFar: ( newReservationEntries ){
                    setState(() {
                      reservations.addAll( newReservationEntries );
                    });
                  }
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
}

class ReservationsFoundList extends StatelessWidget {
  const ReservationsFoundList({super.key, required this.reservations});

  final List<Reservation> reservations;

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return const Text("No reservations.");
    } else {
      return SizedBox(
        width: min(MediaQuery.sizeOf(context).width, 900),
        height: 200,
        child: ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return Center(child: Text(reservation.id));
          },
        ),
      );
    }
  }
}

class ReservationAdditionButton extends StatelessWidget {
  const ReservationAdditionButton(
      {super.key,
      required this.description,
      required this.icon,
      required this.onTap,
      this.children});

  final String description;
  final IconData icon;
  final void Function() onTap;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final dimension = min(
            160,
            min(MediaQuery.sizeOf(context).width / 3,
                MediaQuery.sizeOf(context).height / 3))
        .toDouble();

    return SizedBox(
      height: dimension,
      width: dimension,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).colorScheme.secondary,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: 32,
              ),
              Positioned(
                bottom: 8,
                child: Text(description),
              ),
              ...?children
            ],
          ),
        ),
      ),
    );
  }
}
