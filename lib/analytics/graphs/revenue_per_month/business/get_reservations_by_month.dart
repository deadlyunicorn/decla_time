import "package:decla_time/analytics/graphs/revenue_per_month/business/reservations_of_month_of_year.dart";
import "package:decla_time/analytics/graphs/taxes_per_year/business/get_reservations_by_year.dart";
import "package:decla_time/reservations/reservation.dart";

///Probably computationally expensive. Don't call it too often.
///Reservations are considered sorted beforehands.
///it returns a list where each element is `{year,month,List<Reservation>}`
List<ReservationsOfMonthOfYear> getReservationsByMonthForAnalytics(
  List<ReservationsOfYear> reservationsGroupedByYear,
) {
  //! Analytics should be done based on arrival date,
  //! As they do not pay the last day ( departure date ).
  final List<ReservationsOfMonthOfYear> reservationsGroupedByMonth =
      <ReservationsOfMonthOfYear>[];

  for (int i = 0; i < reservationsGroupedByYear.length; i++) {
    //reservations are considered already sorted
    final ReservationsOfYear reservationsOfYear = reservationsGroupedByYear[i];
    final int currentYear = reservationsOfYear.year;

    // int indexOfCurrentItem = -1;
    for (int j = 0; j < reservationsOfYear.reservations.length; j++) {
      final Reservation currentReservation = reservationsOfYear.reservations[j];
      final int currentReservationDepartureMonth =
          currentReservation.departureDate.month;
      final int currentReservationArrivalMonth =
          currentReservation.arrivalDate.month;

      if (currentReservationArrivalMonth != currentReservationDepartureMonth) {
        for (int currentMonth = currentReservationArrivalMonth;
            currentMonth <= currentReservationDepartureMonth;
            currentMonth++) {
          if (reservationsGroupedByMonth
                  .where(
                    (ReservationsOfMonthOfYear reservationsByMonth) =>
                        reservationsByMonth.month == currentMonth &&
                        reservationsByMonth.year == currentYear,
                  )
                  .firstOrNull ==
              null) {
            reservationsGroupedByMonth.add(
              ReservationsOfMonthOfYear(
                year: currentYear,
                month: currentMonth,
              ),
            );
          }

          final DateTime correctedArrivalDate =
              currentMonth == currentReservationArrivalMonth
                  ? currentReservation.arrivalDate
                  //? On analytics we basically count the departure date
                  //? So we will make it arrival date on the last day
                  //? of the previous month
                  //? departure date on the last day of the current month
                  : DateTime(currentYear, currentMonth, 1, 13);

          final DateTime correctedDepartureDate =
              currentMonth == currentReservationDepartureMonth
                  ? currentReservation.departureDate
                  : DateTime(currentYear, currentMonth + 1, 1, 11);

          final double correctedPayout = currentReservation.dailyRate *
              (correctedDepartureDate.difference(correctedArrivalDate).inDays +
                  1);

          final Reservation correctedReservation = currentReservation.copyWith(
            arrivalDate: correctedArrivalDate,
            departureDate: correctedDepartureDate,
            payout: currentReservation.payout == 0 ? 0 : correctedPayout,
            cancellationAmount: currentReservation.cancellationAmount == null
                ? null
                //? Think about case where arrivalDate == 01/01 and departure is also 01/01 due to split
                : correctedPayout,
          );

          reservationsGroupedByMonth
              .where(
                (ReservationsOfMonthOfYear reservationsOfMonth) =>
                    (reservationsOfMonth.year == currentYear) &&
                    reservationsOfMonth.month == currentMonth,
              )
              .first
              .reservations
              .add(correctedReservation);
        }
      } else {
        if (reservationsGroupedByMonth
                .where(
                  (ReservationsOfMonthOfYear reservationsByMonth) =>
                      reservationsByMonth.month ==
                          currentReservationArrivalMonth &&
                      reservationsByMonth.year == currentYear,
                )
                .firstOrNull ==
            null) {
          reservationsGroupedByMonth.add(
            ReservationsOfMonthOfYear(
              year: currentYear,
              month: currentReservationArrivalMonth,
            ),
          );
          // indexOfCurrentItem = reservationsGroupedByMonth.length -1 ;
        }
        reservationsGroupedByMonth.last.reservations.add(currentReservation);
      }
    }
  }

  return reservationsGroupedByMonth
    ..sort(
      (ReservationsOfMonthOfYear a, ReservationsOfMonthOfYear b) => b
          .reservations.first.arrivalDate
          .compareTo(a.reservations.first.arrivalDate),
    );
}
