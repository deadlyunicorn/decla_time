import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservation_of_month_grid_view.dart';
import 'package:decla_time/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReservationsOfYear extends StatelessWidget {
  const ReservationsOfYear(
      {super.key, required this.reservationsMapYear, required this.year});

  final Map<int, List<Reservation>> reservationsMapYear;
  final int year;

  @override
  Widget build(BuildContext context) {
    

    return ListView.builder( // A list where entries are separated by month.
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reservationsMapYear.values.length,
        itemBuilder: (context, index) {

          int month = reservationsMapYear.keys.toList()[index];
          final reservationsOfMonth = reservationsMapYear[month]!;

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  children: [
                    Padding( //Month in local format.
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        DateFormat.MMMM( context.watch<SettingsController>().locale ).format(
                          DateTime(0, month),
                        ),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    ReservationOfMonthGridView(
                      reservationsOfMonth: reservationsOfMonth
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
