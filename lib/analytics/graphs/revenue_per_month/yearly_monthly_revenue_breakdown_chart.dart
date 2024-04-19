import "dart:math";

import "package:decla_time/analytics/graphs/revenue_per_month/monthly_revenue_line_chart.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class YearlyMonthlyRevenueBreakdownChart extends StatelessWidget {
  const YearlyMonthlyRevenueBreakdownChart({
    required this.localized,
    required this.reservationsByMonthByYear,
    super.key,
  });

  final AppLocalizations localized;
  final List<ReservationsOfMonthOfYear> reservationsByMonthByYear;

  @override
  Widget build(BuildContext context) {
    final List<int> years = reservationsByMonthByYear
        .map((ReservationsOfMonthOfYear reservationsOfMonthOfYear) =>
            reservationsOfMonthOfYear.year)
        .toSet()
        .toList();

    final double greatestMonthIncome = reservationsByMonthByYear.fold(
      0,
      (double previousValue, ReservationsOfMonthOfYear element) =>
          max(element.monthTotal, previousValue),
    );

    return SizedBox(
      height: 560,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        scrollDirection: Axis.horizontal,
        itemCount: years.length,
        itemBuilder: (BuildContext context, int index) {
          final List<ReservationsOfMonthOfYear> reservationsByMonthOfYear =
              reservationsByMonthByYear
                  .where(
                    (ReservationsOfMonthOfYear element) =>
                        element.year == years[index],
                  )
                  .toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: MonthlyRevenueLineChart(
              localized: localized,
              greatestMonthIncome: greatestMonthIncome,
              reservationsByMonthOfYear: reservationsByMonthOfYear,
            ),
          );
        },
      ),
    );
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
            (reservation.cancellationAmount ?? 0),
      );
}
