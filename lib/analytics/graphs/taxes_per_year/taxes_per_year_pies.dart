import "package:decla_time/analytics/graphs/taxes_per_year/business/get_reservations_by_year.dart";
import "package:decla_time/analytics/graphs/taxes_per_year/tax_year_pie.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class TaxesPerYearPies extends StatelessWidget {
  const TaxesPerYearPies({
    required this.localized,
    required this.reservationsGroupedByYear,
    super.key,
  });

  final AppLocalizations localized;
  final List<ReservationsOfYear> reservationsGroupedByYear;
  final double graphSize = 160;

  @override
  Widget build(BuildContext context) {
    return ColumnWithSpacings(
      spacing: 16,
      children: <Widget>[
        Text(
          localized.taxesPerYear.capitalized,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(
          height: graphSize * 2,
          child: ListView.builder(
            shrinkWrap: MediaQuery.sizeOf(context).width >
                reservationsGroupedByYear.length * graphSize,
            scrollDirection: Axis.horizontal,
            itemCount: reservationsGroupedByYear.length,
            itemBuilder: (BuildContext context, int index) => Center(
              child: TaxYearPie(
                localized: localized,
                size: graphSize,
                reservationsOfYear: reservationsGroupedByYear[index],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
