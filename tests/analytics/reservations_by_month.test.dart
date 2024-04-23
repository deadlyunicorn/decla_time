import "package:decla_time/analytics/graphs/revenue_per_month/business/get_reservations_by_month.dart";
import "package:decla_time/analytics/graphs/revenue_per_month/business/reservations_of_month_of_year.dart";
import "package:decla_time/analytics/graphs/taxes_per_year/business/get_reservations_by_year.dart";
import "package:decla_time/core/enums/booking_platform.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:test/test.dart";

void main() {
  final Reservation reservation1 = Reservation(
    bookingPlatform: BookingPlatform.airbnb,
    listingName: null,
    id: "123123",
    guestName: "haha",
    arrivalDate: DateTime(2021, 04, 02),
    departureDate: DateTime(2021, 08, 02, 11),
    payout: 2400,
    reservationStatus: "completed",
    cancellationDate: null,
    cancellationAmount: null,
  );

  final List<ReservationsOfMonthOfYear> reservationsByMonth =
      getReservationsByMonthForAnalytics(
    getReservationsByYear(
      reservations: <Reservation>[reservation1],
    ),
  );

  test(
    "Reservatiosn are being split by month properly,"
    "when it comes to analytics",
    () {
      expect(
        reservationsByMonth.length,
        reservation1.departureDate.month - reservation1.arrivalDate.month + 1,
      );

      final double totalPayout = reservationsByMonth.fold<double>(
        0,
        (double previousValue, ReservationsOfMonthOfYear element) =>
            previousValue + element.monthTotal,
      );
      expect(totalPayout, 2400);

      final double totalNights = reservationsByMonth.fold<double>(
        0,
        (double previousValue, ReservationsOfMonthOfYear reservationsOfMonth) =>
            previousValue +
            reservationsOfMonth.reservations.fold(
              0,
              (num previousValue, Reservation reservations) =>
                  previousValue + reservations.nights,
            ),
      );
      expect(totalNights, reservation1.nights);
    },
  );
}
