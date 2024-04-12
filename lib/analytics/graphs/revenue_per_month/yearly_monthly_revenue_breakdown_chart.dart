import "package:decla_time/analytics/graphs/revenue_per_month/business/get_reservations_by_month.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/monthly_revenue_line_chart.dart";
import "package:decla_time/analytics/graphs/taxes_per_year/business/get_reservations_by_year.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

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

    return SizedBox(
      height: 560,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        scrollDirection: Axis.horizontal,
        itemCount: years.length,
        itemBuilder: (BuildContext context, int index) {
          final List<ReservationsOfMonthOfYear> reservationsByMonthOfYear =
              getReservationsByMonth(reservationsGroupedByYear)
                  .where(
                    (ReservationsOfMonthOfYear element) =>
                        element.year == years[index],
                  )
                  .toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: MonthlyRevenueLineChart(
              localized: localized,
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
