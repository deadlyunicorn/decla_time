import "package:decla_time/analytics/graphs/revenue_per_month/business/reservations_of_month_of_year.dart";
import "package:decla_time/analytics/graphs/taxes_per_year/business/get_reservations_by_year.dart";
import "package:decla_time/reservations/reservation.dart";

///Probably computationally expensive. Don't call it too often.
///Reservations are considered sorted beforehands.
///it returns a list where each element is `{year,month,List<Reservation>}`
List<ReservationsOfMonthOfYear> getReservationsByMonth(
  List<ReservationsOfYear> reservationsGroupedByYear,
) {
  final List<ReservationsOfMonthOfYear> reservationsGroupedByMonth =
      <ReservationsOfMonthOfYear>[];

  for (int i = 0; i < reservationsGroupedByYear.length; i++) {
    //reservations are considered already sorted
    final ReservationsOfYear reservationsOfYear = reservationsGroupedByYear[i];
    int currentMonth = -1;
    // int indexOfCurrentItem = -1;
    for (int j = 0; j < reservationsOfYear.reservations.length; j++) {
      final Reservation currentReservation = reservationsOfYear.reservations[j];
      if (currentReservation.departureDate.month != currentMonth) {
        currentMonth = currentReservation.departureDate.month;
        reservationsGroupedByMonth.add(
          ReservationsOfMonthOfYear(
            year: reservationsOfYear.year,
            month: currentMonth,
          ),
        );
        // indexOfCurrentItem = reservationsGroupedByMonth.length -1 ;
      }
      reservationsGroupedByMonth.last.reservations.add(currentReservation);
    }
  }

  return reservationsGroupedByMonth;
}
