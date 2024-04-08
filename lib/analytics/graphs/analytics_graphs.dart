import "package:decla_time/analytics/graphs/taxes_per_year/business/get_reservations_by_year.dart";
import "package:decla_time/analytics/graphs/taxes_per_year/taxes_per_year_pies.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class AnalyticsGraphs extends StatelessWidget {
  const AnalyticsGraphs({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ReservationsOfYear>>(
      future: getReservationsByYearFuture(context: context),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ReservationsOfYear>?> snapshot,
      ) {
        return ColumnWithSpacings(
          //TODO Pass required data by props
          spacing: 16,
          children: <Widget>[
            TaxesPerYearPies(
              localized: localized,
              reservationsGroupedByYear:
                  snapshot.data ?? <ReservationsOfYear>[],
            ),
            Text(localized.howToGetTheFiles),
            Text(localized.howToGetTheFiles),
          ],
        );
      },
    );
  }
}
