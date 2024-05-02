import "dart:math";

import "package:decla_time/analytics/graphs/performance_comparison/rows/percentage_difference_row.dart";
import "package:decla_time/analytics/graphs/performance_comparison/rows/rate_difference_row.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/business/reservations_of_month_of_year.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class PerformanceComparedToLastYear extends StatelessWidget {
  const PerformanceComparedToLastYear({
    required this.reservationsByMonthByYear,
    required this.localized,
    super.key,
  });

  final List<ReservationsOfMonthOfYear> reservationsByMonthByYear;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final ReservationsDetails recentReservations =
        ReservationsDetails(durationInDays: 30 * 3);
    final ReservationsDetails olderReservations =
        ReservationsDetails(durationInDays: 365);

    if (reservationsByMonthByYear.isNotEmpty) {
      for (final ReservationsOfMonthOfYear reservationsOfMonth
          in reservationsByMonthByYear) {
        for (final Reservation reservation
            in reservationsOfMonth.reservations) {
          if (DateTime.now().difference(reservation.arrivalDate).inDays <=
              30 * 3) {
            recentReservations.reservations.add(reservation);
          }
          if (DateTime.now().difference(reservation.arrivalDate).inDays <=
              //* else if would need adjustment when dividing below.
              365) {
            olderReservations.reservations.add(reservation);
          }
        }
      }
    }

    final bool noEnoughData = recentReservations.reservations.isEmpty ||
        recentReservations.reservations.isEmpty;

    //? Basically we compare last 3 month compared to last 365
    //? Total Nights / Duration

    final double averageDailyRateDifference =
        recentReservations.averageNightlyRate -
            olderReservations.averageNightlyRate;

    final double nightsFilledPercentageDifference =
        recentReservations.nightsFilledPercentage -
            olderReservations.nightsFilledPercentage;

    return ColumnWithSpacings(
      spacing: 32,
      children: <Widget>[
        Text(
          localized.performanceComparedToPastYear.capitalized,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        noEnoughData
            ? Text(localized.noEnoughData.capitalized)
            : Column(
                children: <Widget>[
                  PercentageDifferenceRow(
                    localized: localized,
                    recentFilledPercentage:
                        recentReservations.nightsFilledPercentage,
                    olderFilledPercentage:
                        olderReservations.nightsFilledPercentage,
                    nightsFilledPercentageDifference:
                        nightsFilledPercentageDifference,
                    textColor: getColorForAverageDailyRateDiff(
                      rateDifference: nightsFilledPercentageDifference,
                      maximumValue: max(
                        recentReservations.nightsFilledPercentage,
                        olderReservations.nightsFilledPercentage,
                      ),
                    ),
                  ),
                  RateDifferenceRow(
                    localized: localized,
                    recentDailyRate: recentReservations.averageNightlyRate,
                    olderDailyRate: olderReservations.averageNightlyRate,
                    averageDailyRateDifference: averageDailyRateDifference,
                    textColor: getColorForAverageDailyRateDiff(
                      rateDifference: averageDailyRateDifference,
                      maximumValue: max(
                        recentReservations.averageNightlyRate,
                        olderReservations.averageNightlyRate,
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Color getColorForAverageDailyRateDiff({
    required double rateDifference,
    required double maximumValue,
  }) {
    if (rateDifference.abs() <= maximumValue * 0.05) {
      return Colors.amber.shade700;
    } else if (rateDifference > maximumValue * 0.05) {
      return Colors.greenAccent.shade700;
    } else {
      return Colors.red;
    }
  }
}

class ReservationsDetails {
  ReservationsDetails({
    required this.durationInDays,
  });
  final List<Reservation> reservations = <Reservation>[];
  final int durationInDays;

  double get averageNightlyRate =>
      (reservations.fold<double>(
                0,
                (double previousValue, Reservation element) =>
                    (element.dailyRate + previousValue) / 2,
              ) *
              100)
          .round() /
      100;

  double get nightsFilledPercentage =>
      reservations.fold(
        0,
        (int previousValue, Reservation element) =>
            element.nights + previousValue,
      ) /
      durationInDays;
}
