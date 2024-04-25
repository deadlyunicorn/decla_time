import "package:decla_time/analytics/graphs/taxes_per_year/tax_calculation_details_route/tax_calculation_details_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class YearTaxDetailsButton extends StatelessWidget {
  const YearTaxDetailsButton({
    required this.yearString,
    required this.grossValue,
    required this.localized,
    required this.year,
    super.key,
  });

  final String yearString;
  final double grossValue;
  final AppLocalizations localized;
  final int year;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => TaxCalculationDetailsRoute(
              localized: localized,
              year: year,
              grossValue: grossValue,
            ),
          ),
        );
      },
      child: Text(
        yearString,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
