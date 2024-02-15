import 'dart:math';

import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/reservations/reservation.dart';
import 'package:decla_time/reservations/business/reservation_actions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:decla_time/reservations/presentation/reservations_list/reservations_of_year_list.dart';
import 'package:flutter/material.dart';

class ReservationsList extends StatelessWidget {
  const ReservationsList({super.key, required this.reservations, required this.localized});

  final List<Reservation> reservations;
  final AppLocalizations localized; 

  @override
  Widget build(BuildContext context) {
    final yearMonthMap =
        ReservationActions.genereateYearMonthMap(reservations);

    if (reservations.isNotEmpty) {
      return ListView.builder(
        // A list where entries are separated by year.
        itemCount: yearMonthMap.entries.length,
        itemBuilder: (context, index) {
          final int year = yearMonthMap.keys.toList()[index];

          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox.square(dimension: 32),
              Text(
                "$year",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                width: min(MediaQuery.sizeOf(context).width, kMaxWidthLargest),
                child: ReservationsOfYear(
                  localized: localized,
                  reservationsMapYear: yearMonthMap[year]!,
                ),
              ),
            ],
          );
        },
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            localized.reservationsNotFoundLocally.capitalized,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
