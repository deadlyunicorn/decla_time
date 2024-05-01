import "package:decla_time/analytics/graphs/taxes_per_year/business/get_reservations_by_year.dart";
import "package:decla_time/core/enums/booking_platform.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:test/test.dart";

void main() {
  test("Edge cases for grouping reservations by year", () {
    final Reservation reservation = Reservation(
      bookingPlatform: BookingPlatform.airbnb,
      listingName: null,
      id: "123123",
      guestName: "haha",
      arrivalDate: DateTime(2021, 04, 02),
      departureDate: DateTime(2024, 02, 01, 11),
      payout: 2400,
      reservationStatus: "completed",
      cancellationDate: null,
      cancellationAmount: null,
      reservationPlaceId: 1,
    );

    final List<Reservation> splitReservations = reservationSplitOnYearChange(
      reservation: reservation,
    );

    expect(splitReservations.first.departureDate, DateTime(2021, 12, 31, 11));

    expect(splitReservations[1].departureDate, DateTime(2022, 12, 31, 11));
    expect(splitReservations[2].arrivalDate, DateTime(2023, 1, 1, 13));
    expect(splitReservations[2].departureDate, DateTime(2023, 12, 31, 11));
    expect(splitReservations[3].departureDate, DateTime(2024, 02, 01, 11));

    final int totalNightsOfSplit = splitReservations.fold<int>(
      0,
      (int previousValue, Reservation element) =>
          previousValue + element.nights,
    );

    expect(
      totalNightsOfSplit,
      //! We lose one night per year..
      reservation.nights -
          (reservation.departureDate
                      .difference(reservation.arrivalDate)
                      .inDays /
                  365)
              .round(),
    );

    final double totalPayoutOfSplit = splitReservations.fold<double>(
      0,
      (double previousValue, Reservation element) =>
          previousValue + element.payout,
    );
    expect(totalPayoutOfSplit, reservation.payout);

    expect(
      splitReservations.first.payout.toStringAsFixed(2),
      (reservation.dailyRate *
              DateTime(reservation.arrivalDate.year + 1)
                  .difference(reservation.arrivalDate)
                  .inDays)
          .toStringAsFixed(2),
    );
  });

  test("Edge cases for grouping reservations by year, 2011", () {
    final Reservation reservation = Reservation(
      bookingPlatform: BookingPlatform.airbnb,
      listingName: null,
      id: "123123",
      guestName: "haha",
      arrivalDate: DateTime(2011, 04, 02),
      departureDate: DateTime(2024, 02, 01, 11),
      payout: 2400,
      reservationStatus: "completed",
      cancellationDate: null,
      cancellationAmount: null,
      reservationPlaceId: 1,
    );

    final List<Reservation> splitReservations = reservationSplitOnYearChange(
      reservation: reservation,
    );

    final int totalNightsOfSplit = splitReservations.fold<int>(
      0,
      (int previousValue, Reservation element) =>
          previousValue + element.nights,
    );

    expect(
      totalNightsOfSplit,
      reservation.nights -
          (reservation.departureDate
                      .difference(reservation.arrivalDate)
                      .inDays /
                  365)
              .round(),
    );

    final double totalPayoutOfSplit = splitReservations.fold<double>(
      0,
      (double previousValue, Reservation element) =>
          previousValue + element.payout,
    );
    expect(totalPayoutOfSplit, reservation.payout);

    expect(
      splitReservations.first.payout.toStringAsFixed(2),
      (reservation.dailyRate *
              DateTime(reservation.arrivalDate.year + 1)
                  .difference(reservation.arrivalDate)
                  .inDays)
          .toStringAsFixed(2),
    );
  });
}
