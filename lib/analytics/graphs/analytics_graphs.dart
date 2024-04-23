import "package:decla_time/analytics/graphs/revenue_per_month/business/get_reservations_by_month.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/business/reservations_of_month_of_year.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/yearly_monthly_revenue_breakdown_chart.dart";
import "package:decla_time/analytics/graphs/taxes_per_year/business/get_reservations_by_year.dart";
import "package:decla_time/analytics/graphs/taxes_per_year/taxes_per_year_pies.dart";
import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:isar/isar.dart";
import "package:provider/provider.dart";

class AnalyticsGraphs extends StatelessWidget {
  const AnalyticsGraphs({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Reservation>>(
      future: getAllReservationsFromDatabaseFuture(context: context),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<Reservation>?> snapshot,
      ) {
        final List<ReservationsOfYear> reservationsByYear =
            snapshot.data != null
                ? getReservationsByYear(reservations: snapshot.data!)
                : <ReservationsOfYear>[];
        final List<ReservationsOfMonthOfYear> reservationsByMonthByYear =
            snapshot.data != null
                ? getReservationsByMonthForAnalytics(reservationsByYear)
                : <ReservationsOfMonthOfYear>[];
        return ColumnWithSpacings(
          spacing: 16,
          children: <Widget>[
            //TODO Click on a year that takes you to a new page with more expectations for the year
            YearlyMonthlyRevenueBreakdownChart(
              localized: localized,
              reservationsByMonthByYear: reservationsByMonthByYear,
            ),
            // * Moved inside the YearlyMonthlyRevenueBreadkownChart
            // * as an optional chart.
            // DaysFilledPerMonthChart(
            //   localized: localized,
            //   reservationsByMonthByYear: reservationsByMonthByYear,
            // ),

            //TODO - Average Daily Rate (ADR) Chart
            //
            TaxesPerYearPies(
              localized: localized,
              reservationsGroupedByYear: reservationsByYear,
            ),

           
          ],
        );
      },
    );
  }

  Future<List<Reservation>> getAllReservationsFromDatabaseFuture({
    required BuildContext context,
  }) async {
    final Isar isar = await context.read<IsarHelper>().isarFuture;
    return await isar.reservations.where().sortByDepartureDateDesc().findAll();
  }
}
