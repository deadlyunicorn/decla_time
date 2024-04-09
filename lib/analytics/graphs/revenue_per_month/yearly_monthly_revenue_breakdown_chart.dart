import "package:decla_time/analytics/graphs/taxes_per_year/business/get_reservations_by_year.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:intl/intl.dart";

class YearlyMonthlyRevenueBreakdownChart extends StatelessWidget {
  const YearlyMonthlyRevenueBreakdownChart({
    required this.localized,
    required this.reservationsGroupedByYear,
    super.key,
  });

  final AppLocalizations localized;
  final List<ReservationsOfYear> reservationsGroupedByYear;

  @override
  Widget build(BuildContext context) {
    final List<int> years = reservationsGroupedByYear
        .map((ReservationsOfYear reservationsOfYear) => reservationsOfYear.year)
        .toList();

    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final List<ReservationsOfMonthOfYear> reservationsByMonthOfYear =
            reservationsByMonth
                .where((ReservationsOfMonthOfYear element) =>
                    element.year == years[index])
                .toList();

        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final ReservationsOfMonthOfYear reservationsOfMonth =
                reservationsByMonthOfYear[index];

            return Text(DateFormat("MMMM - y: ").format(DateTime(
                    reservationsOfMonth.year, reservationsOfMonth.month)) +
                reservationsOfMonth.monthTotal.toStringAsFixed(2));
          },
          itemCount: reservationsByMonthOfYear.length,
        );
      },
      itemCount: years.length,
    );
  }

  ///Probably computationally expensive. Don't call it too often.
  ///Reservations are considered sorted beforehands.
  ///it returns a list where each element is `{year,month,List<Reservation>}`
  List<ReservationsOfMonthOfYear> get reservationsByMonth {
    final List<ReservationsOfMonthOfYear> reservationsGroupedByMonth =
        <ReservationsOfMonthOfYear>[];

    for (int i = 0; i < reservationsGroupedByYear.length; i++) {
      //reservations are considered already sorted
      final ReservationsOfYear reservationsOfYear =
          reservationsGroupedByYear[i];
      int currentMonth = -1;
      // int indexOfCurrentItem = -1;
      for (int j = 0; j < reservationsOfYear.reservations.length; j++) {
        final Reservation currentReservation =
            reservationsOfYear.reservations[j];
        if (currentReservation.departureDate.month != currentMonth) {
          currentMonth = currentReservation.departureDate.month;
          reservationsGroupedByMonth.add(
            ReservationsOfMonthOfYear(
              year: reservationsOfYear.year,
              month: currentMonth,
            ),
          );
          // indexOfCurrentItem = reservationsGroupedByMonth.length -1 ;
        }
        reservationsGroupedByMonth.last.reservations.add(currentReservation);
      }
    }

    return reservationsGroupedByMonth;
  }
}

// April .. Jan  // Dec Nov .. Feb Jan //
// 2024         //       2023         ///

class ReservationsOfMonthOfYear {
  final int year;
  final int month;
  final List<Reservation> reservations = <Reservation>[];

  ReservationsOfMonthOfYear({
    required this.year,
    required this.month,
  });

  double get monthTotal => reservations.fold(
      0,
      (double previousValue, Reservation reservation) =>
          previousValue +
          reservation.payout +
          (reservation.cancellationAmount ?? 0));
}
