import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class LineChartSample7 extends StatelessWidget {
  const LineChartSample7({
    super.key,
  });

  //A List of the months with the average reservation prices.

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      // width: 480,
      child: LineChart(
        LineChartData(
          lineTouchData: const LineTouchData(enabled: false),
          lineBarsData: <LineChartBarData>[
            averagePerMonthGraphNegatives(),
            averagePerMonthGraph(),
          ],
          extraLinesData: ExtraLinesData(
            extraLinesOnTop: true,
            horizontalLines: <HorizontalLine>[
              HorizontalLine(
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
              ),
            ],
          ),
          minY: 0,
          borderData: FlBorderData(
            show: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) =>
                    SideTitleWidget(
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
                getTitlesWidget: (double value, TitleMeta meta) =>
                    SideTitleWidget(
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
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            checkToShowHorizontalLine: (double value) {
              return value == 1 || value == 6 || value == 4 || value == 5;
            },
          ),
        ),
      ),
    );
  }

  LineChartBarData averagePerMonthGraph() {
    return LineChartBarData(
      spots: const <FlSpot>[
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
        //*OR in order to hide, use the same color as the bacgkround
        show: true,
        applyCutOffY: true,
        cutOffY: 45, //Average
      ),
      isCurved: false,
      barWidth: 2,
      color: Colors.white,
      dashArray: <int>[
        2
      ,],
      dotData: FlDotData(
        show: false,
      ),
    );
  }

  LineChartBarData averagePerMonthGraphNegatives() {
    return LineChartBarData(
      spots: const <FlSpot>[
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

      // aboveBarData: BarAreaData(color: Colors.green, show: true,applyCutOffY: true),
      belowBarData: BarAreaData(
        color: Colors.redAccent.shade700,
        show: true,
      ),
      isCurved: false,
      barWidth: 2,
      color: Colors.transparent,
      dotData: const FlDotData(
        show: false,
      ),
    );
  }
}
