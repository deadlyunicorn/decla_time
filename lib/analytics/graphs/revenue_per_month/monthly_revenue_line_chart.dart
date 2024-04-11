import "package:decla_time/analytics/graphs/revenue_per_month/show_areas_button.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/show_average_button.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class MonthlyRevenueLineChart extends StatefulWidget {
  const MonthlyRevenueLineChart({
    super.key,
  });

  @override
  State<MonthlyRevenueLineChart> createState() =>
      _MonthlyRevenueLineChartState();
}

class _MonthlyRevenueLineChartState extends State<MonthlyRevenueLineChart> {
  bool showAverage = false;
  bool showAreas = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ShowAverageButton(
          showAverage: showAverage,
          setShowAverage: setShowAverage,
        ),
        ShowAreasButton(
          showAreas: showAreas,
          setShowAreas: setShowAreas,
        ),
        Expanded(
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
              minY: 0,
              maxY: (123 / 10).ceil() * 10, // max / 10 -> round * 10
              borderData: FlBorderData(
                show: false,
              ),
              titlesData: getTitles(context),
              gridData: const FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  FlTitlesData getTitles(BuildContext context) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (double value, TitleMeta meta) => SideTitleWidget(
            axisSide: meta.axisSide,
            space: 4,
            child: Text(
              DateFormat("MMMM").format(DateTime(0, value.toInt())),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (double value, TitleMeta meta) => SideTitleWidget(
            axisSide: meta.axisSide,
            child: Text(
              "${value.toStringAsFixed(2)} EUR",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          interval: 20, // ( max - min ) - / 10
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
      y: 45,
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
        labelResolver: (HorizontalLine _) => "Average: 45.00 EUR",
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
        getTooltipColor: (LineBarSpot touchedSpot) =>
            Theme.of(context).colorScheme.secondary,
        getTooltipItems: (List<LineBarSpot> touchedSpots) =>
            touchedSpots.map((LineBarSpot spot) {
          return spot.barIndex == 0
              ? LineTooltipItem(
                  "${DateFormat.MMM().format(DateTime(0, spot.x.toInt()))}: "
                  "${spot.y} EUR",
                  Theme.of(context).textTheme.bodySmall!,
                )
              : null;
          //?We use 2 graphs, one to display red below average
          //?and one to display green above average.
          //?The above expression prevents showing 2 times the tooltip
        }).toList(),
      ),
    );
  }

  LineChartBarData generateLineBarsData({
    required bool showAreas,
  }) {
    return LineChartBarData(
      spots: <FlSpot>[
        FlSpot(0, 86),
        FlSpot(1, 123),
        FlSpot(2, 4),
        FlSpot(3, 45),
        FlSpot(4, 3),
        FlSpot(5, 96),
        FlSpot(6, 5),
        FlSpot(7, 3),
        FlSpot(8, 1),
        FlSpot(9, 45),
        FlSpot(10, 1),
        FlSpot(11, 100),
      ],
      belowBarData: BarAreaData(
        color: Colors.greenAccent.shade700,
        //   //*OR in order to hide, use the same color as the bacgkround
        show: showAreas,
        applyCutOffY: true,
        cutOffY: 45, //Average
      ),
      aboveBarData: BarAreaData(
        color: Colors.redAccent.shade700,
        cutOffY: 45,
        applyCutOffY: true,
        show: showAreas,
      ),
      // isCurved: false,
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
}
