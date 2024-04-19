import "package:decla_time/analytics/graphs/days_filled_per_month/days_filled_per_month_chart.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/business/reservations_of_month_of_year.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/show_areas_button.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/show_average_button.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/show_average_night_rate_button.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/show_nights_per_month_button.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import "package:intl/intl.dart";

class MonthlyRevenueLineChart extends StatefulWidget {
  const MonthlyRevenueLineChart({
    required this.reservationsByMonthOfYear,
    required this.localized,
    required this.greatestMonthIncome,
    super.key,
  });

  final AppLocalizations localized;

  final List<ReservationsOfMonthOfYear> reservationsByMonthOfYear;
  final double greatestMonthIncome;

  double get minMonthPayOfYear => reservationsByMonthOfYear.fold(
        double.infinity,
        (double previousValue, ReservationsOfMonthOfYear currentValue) {
          final double currentMonthTotal = currentValue.monthTotal;
          return currentMonthTotal < previousValue
              ? currentMonthTotal
              : previousValue;
        },
      );

  double get maxMonthPayOfYear => reservationsByMonthOfYear.fold(
        0,
        (double previousValue, ReservationsOfMonthOfYear currentValue) {
          final double currentMonthTotal = currentValue.monthTotal;
          return currentMonthTotal > previousValue
              ? currentMonthTotal
              : previousValue;
        },
      );
  double get yearAverage =>
      reservationsByMonthOfYear.fold<double>(
        0,
        (double previousValue, ReservationsOfMonthOfYear currentValue) =>
            previousValue + currentValue.monthTotal,
      ) /
      reservationsByMonthOfYear.length;

  @override
  State<MonthlyRevenueLineChart> createState() =>
      _MonthlyRevenueLineChartState();
}

class _MonthlyRevenueLineChartState extends State<MonthlyRevenueLineChart> {
  bool showAverage = false;
  bool showAreas = false;
  bool showNightsPerMonth = false;
  bool showAverageNightRate = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0), //? Prevent clipping overflow
      child: SizedBox(
        width: 560,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Text(
                      "${widget.reservationsByMonthOfYear.first.year}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  SizedBox(
                    height: 360,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: getLineTouchData(context),
                        lineBarsData: <LineChartBarData>[
                          generateLineBarsData(showAreas: showAreas),
                        ],
                        extraLinesData: ExtraLinesData(
                          extraLinesOnTop: true,
                          horizontalLines: <HorizontalLine>[
                            if (showAverage) displayAverageLine(context),
                          ],
                        ),

                        minX: 1,
                        maxX: 12,
                        minY: 0,
                        maxY: widget.greatestMonthIncome
                            .ceilToDouble(), // max / 10 -> round * 10
                        borderData: FlBorderData(
                          show: false,
                        ),
                        titlesData: getTitles(context),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval:
                              (widget.greatestMonthIncome / 10).ceilToDouble(),
                        ),
                      ),
                    ),
                  ),
                  ShowAreasButton(
                    showAreas: showAreas,
                    setShowAreas: setShowAreas,
                    localized: widget.localized,
                  ),
                  ShowAverageButton(
                    showAverage: showAverage,
                    setShowAverage: setShowAverage,
                    localized: widget.localized,
                  ),
                  ShowAverageNightRateButton(
                    showAverageNightRate: showAverageNightRate,
                    setShowAverageNightRate: (bool? newState) {
                      setState(() {
                        showAverageNightRate = newState ?? false;
                      });
                    },
                    localized: widget.localized,
                  ),
                  ShowNightsPerMonthButton(
                    showNights: showNightsPerMonth,
                    setShowNights: setShowNights,
                    localized: widget.localized,
                  ),
                  const SizedBox.square(
                    dimension: 4,
                  ),
                ],
              ),
            ),
            if (showNightsPerMonth)
              Positioned(
                left: 36,
                child: SizedBox(
                  // color: Colors.green,
                  height: 360,
                  width: 560,
                  child: DaysFilledPerMonthBarChart(
                    showGrid: false,
                    themeData: Theme.of(context),
                    localized: widget.localized,
                    reservationsByMonthOfYear: widget.reservationsByMonthOfYear,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  FlTitlesData getTitles(BuildContext context) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          reservedSize: 48,
          showTitles: true,
          interval: 1,
          getTitlesWidget: (double value, TitleMeta meta) {
            final List<Reservation>? reservationsOfMonth =
                widget.reservationsByMonthOfYear
                    .where(
                      (ReservationsOfMonthOfYear element) =>
                          element.month == value,
                    )
                    .firstOrNull
                    ?.reservations;

            final double averageRate = reservationsOfMonth != null
                ? (reservationsOfMonth.fold<double>(
                      0,
                      (double previousValue, Reservation element) =>
                          previousValue + element.dailyRate,
                    ) /
                    reservationsOfMonth.length)
                : 0;

            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 4,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      DateFormat.MMM(widget.localized.localeName)
                          .format(DateTime(0, value.toInt())),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  if (showAverageNightRate) 
                    reservationsOfMonth != null
                        ? Text(
                            averageRate.toStringAsFixed(2),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: value == 1
                                          ? Colors.amber
                                          : Colors.greenAccent.shade700,
                                    ),
                          )
                        : Tooltip(
                            message: widget.localized.noData.capitalized,
                            child: const Icon(
                              Icons.error_outline_rounded,
                              size: 16,
                            ),
                          ),
                ],
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) => SideTitleWidget(
            axisSide: meta.axisSide,
            child: Center(
              child: Text(
                "${value.toStringAsFixed(2)}€",
                style: Theme.of(context).textTheme.bodySmall,
                // textAlign: TextAlign.center,
              ),
            ),
          ),
          interval: (widget.greatestMonthIncome / 10)
              .ceilToDouble(), // ( max - min ) - / 10
          reservedSize: 72,
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  HorizontalLine displayAverageLine(BuildContext context) {
    return HorizontalLine(
      y: widget.yearAverage,
      color: Colors.yellowAccent.shade700,
      label: HorizontalLineLabel(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.yellowAccent.shade700,
          shadows: <Shadow>[
            const Shadow(
              color: Colors.black,
              blurRadius: 1,
              offset: Offset(2, 2),
            ),
          ],
        ),
        labelResolver: (HorizontalLine _) =>
            "${widget.localized.average.capitalized}: "
            "${widget.yearAverage.toStringAsFixed(2)} EUR",
        show: true,
      ),
      dashArray: <int>[
        10,
      ],
    );
  }

  LineTouchData getLineTouchData(BuildContext context) {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        maxContentWidth: double.infinity,
        getTooltipColor: (LineBarSpot touchedSpot) =>
            Theme.of(context).colorScheme.secondary,
        getTooltipItems: (List<LineBarSpot> touchedSpots) =>
            touchedSpots.map((LineBarSpot spot) {
          return LineTooltipItem(
            // ignore: prefer_interpolation_to_compose_strings
            DateFormat.MMMM(widget.localized.localeName)
                    .format(DateTime(0, spot.x.toInt())) +
                ": ${spot.y.toStringAsFixed(2)} EUR",
            Theme.of(context).textTheme.bodySmall!,
          );
        }).toList(),
      ),
    );
  }

  LineChartBarData generateLineBarsData({
    required bool showAreas,
  }) {
    return LineChartBarData(
      spots: widget.reservationsByMonthOfYear
          .map(
            (ReservationsOfMonthOfYear monthData) =>
                FlSpot(monthData.month.toDouble(), monthData.monthTotal),
          )
          .toList(),
      belowBarData: BarAreaData(
        color: Colors.greenAccent.shade700,
        //   //*OR in order to hide, use the same color as the bacgkround
        show: showAreas,
        applyCutOffY: true,
        cutOffY: widget.yearAverage, //Average
      ),
      aboveBarData: BarAreaData(
        color: Colors.redAccent.shade700,
        cutOffY: widget.yearAverage,
        applyCutOffY: true,
        show: showAreas,
      ),
      // isCurved: true,
      barWidth: 2,
      color: Colors.yellowAccent.shade700,
      dashArray: <int>[
        2,
      ],
      dotData: const FlDotData(
        show: false,
      ),
    );
  }

  void setShowAverage(bool? newState) {
    setState(() {
      showAverage = newState ?? false;
    });
  }

  void setShowAreas(bool? newState) {
    setState(() {
      showAreas = newState ?? false;
    });
  }

  void setShowNights(bool? newState) {
    setState(() {
      showNightsPerMonth = newState ?? false;
    });
  }
}
