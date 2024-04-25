import "package:decla_time/analytics/graphs/taxes_per_year/tax_calculation_details_route/fee_tiers_wrapper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class TaxCalculationDetailsRoute extends StatefulWidget {
  const TaxCalculationDetailsRoute({
    required this.localized,
    required this.grossValue,
    required this.year,
    super.key,
  });

  final AppLocalizations localized;
  final double grossValue;
  final int year;

  @override
  State<TaxCalculationDetailsRoute> createState() =>
      _TaxCalculationDetailsRouteState();
}

class _TaxCalculationDetailsRouteState
    extends State<TaxCalculationDetailsRoute> {
  @override
  void initState() {
    grossValue = widget.grossValue;
    textEditingController.text = widget.grossValue.toStringAsFixed(2);
    super.initState();
  }

  double grossValue = 0;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final List<FeeTier> feeTiers = <FeeTier>[
      FeeTier(feeFactor: 0.09, thresholdString: "<10001", threshHold: 10001),
      FeeTier(feeFactor: 0.22, thresholdString: "<20001", threshHold: 20001),
      FeeTier(feeFactor: 0.28, thresholdString: "<30001", threshHold: 30001),
      FeeTier(feeFactor: 0.36, thresholdString: "<40001", threshHold: 40001),
      FeeTier(feeFactor: 0.44, thresholdString: ">40000", threshHold: 50001),
    ];

    return RouteOutline(
      title: "${widget.localized.taxCalculation.capitalized} ${widget.year}",
      child: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: kMaxWidthSmall,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 64.0),
              child: ColumnWithSpacings(
                spacing: 32,
                children: <Widget>[
                  Text(
                    widget.localized.taxCalculationSummary,
                    textAlign: TextAlign.center,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        // ignore: lines_longer_than_80_chars
                        "${widget.localized.grossValue.capitalized}:",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      TextField(
                        controller: textEditingController,
                        onChanged: (String value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              grossValue = double.parse(value);
                            });
                          }
                        },
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.amberAccent.shade700,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: feeTiers
                        .map(
                          (FeeTier feeTier) => feeTier.threshHold == 50001 ||
                                  feeTier.threshHold > grossValue
                              ? FeeTiersWrapper(
                                  localized: widget.localized,
                                  grossValue: grossValue,
                                  feeTier: feeTier,
                                )
                              : const SizedBox.shrink(),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
