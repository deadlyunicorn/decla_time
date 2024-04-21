import "package:decla_time/analytics/graphs/revenue_per_month/business/reservations_of_month_of_year.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/monthly_revenue_line_chart.dart";
import "package:flutter/material.dart";

class YearlyMonthBreakdownChartsWrapper extends StatelessWidget {
  const YearlyMonthBreakdownChartsWrapper({
    required this.reservationsByMonthByYear,
    required this.chart,
    required this.height,
    super.key,
  });

  final List<ReservationsOfMonthOfYear> reservationsByMonthByYear;
  final Widget Function(
    List<ReservationsOfMonthOfYear> reservationsByMonthOfYear,
  ) chart;
  final int height;

  @override
  Widget build(BuildContext context) {
    final List<int> years = reservationsByMonthByYear
        .map(
          (ReservationsOfMonthOfYear reservationsOfMonthOfYear) =>
              reservationsOfMonthOfYear.year,
        )
        .toSet()
        .toList();

    return SizedBox(
      height: height.toDouble(),
      child: ListView.builder(
        itemExtent: MonthlyRevenueLineChart.graphWidth.toDouble(),
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
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: chart(reservationsByMonthOfYear),
          );
        },
      ),
    );
  }
}
