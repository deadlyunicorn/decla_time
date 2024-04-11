import "package:decla_time/analytics/graphs/revenue_per_month/monthly_revenue_line_chart.dart";
import "package:flutter/material.dart";

class LineChartSample7 extends StatelessWidget {
  const LineChartSample7({
    super.key,
  });

  //A List of the months with the average reservation prices.

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 400,
      // width: 480,
      child: MonthlyRevenueLineChart(),
    );
  }
}
