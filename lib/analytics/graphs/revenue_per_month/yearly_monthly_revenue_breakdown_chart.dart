import "dart:math";

import "package:decla_time/analytics/graphs/revenue_per_month/business/reservations_of_month_of_year.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/monthly_revenue_line_chart.dart";
import "package:decla_time/analytics/widgets/yearly_month_breakdown_charts_wrapper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
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
    final double greatestMonthIncome = reservationsByMonthByYear.fold(
      0,
      (double previousValue, ReservationsOfMonthOfYear element) =>
          max(element.monthTotal, previousValue),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: ColumnWithSpacings(
        spacing: 64,
        children: <Widget>[
          Text(
            localized.incomePerMonth.capitalized,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          YearlyMonthBreakdownChartsWrapper(
            height: MonthlyRevenueLineChart.graphHeight +
                MonthlyRevenueLineChart.buttonReservedHeight +
                32,
            //? GraphHeight + ButtonsHeight + idk what else + Year text.
            reservationsByMonthByYear: reservationsByMonthByYear,
            chart:
                (List<ReservationsOfMonthOfYear> reservationsByMonthOfYear) =>
                    MonthlyRevenueLineChart(
              localized: localized,
              greatestMonthIncome: greatestMonthIncome,
              reservationsByMonthOfYear: reservationsByMonthOfYear,
            ),
          ),
        ],
      ),
    );
  }
}
