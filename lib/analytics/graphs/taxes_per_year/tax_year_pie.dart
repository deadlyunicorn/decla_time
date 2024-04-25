import "package:decla_time/analytics/business/tax_calculation.dart";
import "package:decla_time/analytics/graphs/taxes_per_year/business/get_reservations_by_year.dart";
import "package:decla_time/analytics/graphs/taxes_per_year/year_tax_details_button.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class TaxYearPie extends StatefulWidget {
  const TaxYearPie({
    required this.localized,
    required this.reservationsOfYear,
    required this.size,
    super.key,
  });

  final AppLocalizations localized;
  final ReservationsOfYear reservationsOfYear;
  final double size;
  final TextStyle badgeTextStyle = const TextStyle(
    shadows: <Shadow>[
      Shadow(
        color: Colors.black,
        blurRadius: 1,
        offset: Offset(-1, 1),
      ),
    ],
  );

  double get yearTotal => reservationsOfYear.reservations.fold(
        0,
        (double previousValue, Reservation element) =>
            previousValue + element.payout + (element.cancellationAmount ?? 0),
      );

  TaxCalculation get taxCaclulation => TaxCalculation(
        yearlyIncome: yearTotal,
        untaxedAmount: yearTotal,
      );

  @override
  State<TaxYearPie> createState() => _TaxYearPieState();
}

class _TaxYearPieState extends State<TaxYearPie> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: ColumnWithSpacings(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: <Widget>[
          SizedBox(
            width: widget.size * 3 + 16,
            height: widget.size + 16,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        enabled: false,
                        touchCallback: (
                          FlTouchEvent event,
                          PieTouchResponse? pieTouchResponse,
                        ) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      centerSpaceRadius: (widget.size - 16) / 2,
                      sections: getSections(
                        netIncome: widget.taxCaclulation.totalAfterFees,
                        taxAmount: widget.taxCaclulation.fees,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: YearTaxDetailsButton(
                      localized: widget.localized,
                      grossValue: widget.yearTotal,
                      yearString: widget.reservationsOfYear.year.toString(),
                      year: widget.reservationsOfYear.year,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text("${widget.localized.grossValue.capitalized}: "
                  "${widget.yearTotal.toStringAsFixed(2)} EUR"),
              RowWithSpacings(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${widget.localized.feeFactor.capitalized}: "
                    // ignore: lines_longer_than_80_chars
                    "${(widget.taxCaclulation.taxRate * 100).toStringAsFixed(2)}%",
                  ),
                  Tooltip(
                    message:
                        // ignore: lines_longer_than_80_chars
                        "${widget.localized.yearlyIncome.capitalized} <10001 EUR: \n"
                        "${widget.localized.feeFactor.capitalized} 9%\n\n"
                        // ignore: lines_longer_than_80_chars
                        "${widget.localized.yearlyIncome.capitalized} <20001 EUR: \n"
                        "${widget.localized.feeFactor.capitalized} 22%\n\n"
                        // ignore: lines_longer_than_80_chars
                        "${widget.localized.yearlyIncome.capitalized} <30001 EUR: \n"
                        "${widget.localized.feeFactor.capitalized} 28%\n\n"
                        // ignore: lines_longer_than_80_chars
                        "${widget.localized.yearlyIncome.capitalized} <40001 EUR: \n"
                        "${widget.localized.feeFactor.capitalized} 36%\n\n"
                        // ignore: lines_longer_than_80_chars
                        "${widget.localized.yearlyIncome.capitalized} >40000 EUR: \n"
                        "${widget.localized.feeFactor.capitalized} 44%",
                    textAlign: TextAlign.center,
                    child: const Icon(
                      Icons.info,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getSections({
    required double taxAmount,
    required double netIncome,
  }) =>
      List<PieChartSectionData>.generate(
        2,
        (int i) {
          final bool isTouched = i == touchedIndex;
          final double radius =
              isTouched ? widget.size / 12 + 4 : widget.size / 12;
          final double fontSize = isTouched ? 20 : 16;
          if (i % 2 == 0) {
            return PieChartSectionData(
              color: Colors.deepPurple,
              title: "${widget.localized.fees.capitalized}\n$taxAmount EUR",
              value: taxAmount,
              radius: radius,
              titlePositionPercentageOffset: 5,
              titleStyle: widget.badgeTextStyle.merge(
                TextStyle(
                  fontSize: fontSize,
                ),
              ),
            );
          } else {
            return PieChartSectionData(
              color: Colors.greenAccent.shade700,
              title: "${widget.localized.netValue.capitalized}\n$netIncome EUR",
              value: netIncome,
              radius: radius,
              titlePositionPercentageOffset: 5,
              titleStyle: widget.badgeTextStyle.merge(
                TextStyle(
                  fontSize: fontSize,
                ),
              ),
            );
          }
        },
      );
}
