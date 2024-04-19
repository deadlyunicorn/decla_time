import "package:decla_time/analytics/graphs/revenue_per_month/business/reservations_of_month_of_year.dart";
import "package:decla_time/analytics/widgets/yearly_month_breakdown_charts_wrapper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/night_or_nights.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:intl/intl.dart";

class DaysFilledPerMonthChart extends StatelessWidget {
  const DaysFilledPerMonthChart({
    required this.localized,
    required this.reservationsByMonthByYear,
    super.key,
  });

  final AppLocalizations localized;
  final List<ReservationsOfMonthOfYear> reservationsByMonthByYear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: ColumnWithSpacings(
        spacing: 16,
        children: <Widget>[
          Text(
            localized.nightsPerMonth.capitalized,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          YearlyMonthBreakdownChartsWrapper(
            height: 360,
            reservationsByMonthByYear: reservationsByMonthByYear,
            chart:
                (List<ReservationsOfMonthOfYear> reservationsByMonthOfYear) =>
                    SizedBox(
              width: 640,
              child: ColumnWithSpacings(
                spacing: 16,
                children: <Widget>[
                  Text(
                    reservationsByMonthOfYear.first.year.toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Expanded(
                    child: DaysFilledPerMonthBarChart(
                      showGrid: true,
                      reservationsByMonthOfYear: reservationsByMonthOfYear,
                      themeData: Theme.of(context),
                      localized: localized,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DaysFilledPerMonthBarChart extends StatefulWidget {
  const DaysFilledPerMonthBarChart({
    required this.themeData,
    required this.localized,
    required this.reservationsByMonthOfYear,
    required this.showGrid,
    super.key,
  });

  final ThemeData themeData;
  final AppLocalizations localized;
  final double _addOnHover = 0.5;
  final List<ReservationsOfMonthOfYear> reservationsByMonthOfYear;
  final bool showGrid;

  @override
  State<DaysFilledPerMonthBarChart> createState() =>
      _DaysFilledPerMonthBarChartState();
}

class _DaysFilledPerMonthBarChartState
    extends State<DaysFilledPerMonthBarChart> {
  int? indexOfHoveringBar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(
            show: widget.showGrid,
            drawVerticalLine: false,
            horizontalInterval: 7,
          ),
          minY: 0,
          maxY: 31,
          barTouchData: BarTouchData(
            enabled: true,
            touchCallback: (FlTouchEvent _, BarTouchResponse? touchResponse) {
              final int? newIndex = touchResponse?.spot?.touchedBarGroupIndex;
              if (indexOfHoveringBar != newIndex) {
                setState(() {
                  indexOfHoveringBar = newIndex;
                });
              }
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (BarChartGroupData group) => Colors.transparent,
              tooltipPadding: const EdgeInsets.all(16),
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return (groupIndex == indexOfHoveringBar && rod.toY > 0)
                    ? BarTooltipItem(
                        nightOrNights(
                          widget.localized,
                          rod.toY.round() - (widget._addOnHover).ceil(),
                        ),
                        TextStyle(
                          color: Colors.amber,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                        ),
                      )
                    : null;
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: widget.showGrid,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (double value, TitleMeta meta) => Center(
                  child: Text(
                    DateFormat.MMM(widget.localized.localeName).format(
                      DateTime(
                        0,
                        value.toInt(),
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: widget.showGrid,
                reservedSize: 36,
                interval: 7,
                getTitlesWidget: (double value, TitleMeta meta) => Text(
                  value.round().toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: List<int>.generate(12, (int index) => index + 1).map(
            (int index) {
              final ReservationsOfMonthOfYear? currentMonthDetails =
                  widget.reservationsByMonthOfYear
                      .where(
                        (ReservationsOfMonthOfYear element) =>
                            element.month == index,
                      )
                      .firstOrNull;
              return BarChartGroupData(
                x: index,
                barRods: <BarChartRodData>[
                  BarChartRodData(
                    width: 16,
                    toY: currentMonthDetails != null
                        ? currentMonthDetails.reservations.fold<double>(
                              0,
                              (double previousValue, Reservation reservation) =>
                                  reservation.nights + previousValue,
                            ) +
                            ((indexOfHoveringBar ?? -1) + 1 == index
                                ? widget._addOnHover
                                : 0)
                        : 0,
                    gradient: _barsGradient,
                  ),
                ],
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  LinearGradient get _barsGradient => LinearGradient(
        colors: <Color>[
          widget.themeData.colorScheme.primary,
          widget.themeData.colorScheme.secondary,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
}
