import "dart:math";

import "package:decla_time/reservations/reservation.dart";

List<ReservationsOfYear> getReservationsByYear({
  required List<Reservation> reservations,
}) {
  final List<ReservationsOfYear> reservationsByYear = <ReservationsOfYear>[];

  for (int i = 0; i < reservations.length; i++) {
    final Reservation currentReservation = reservations[i];

    if (!reservationsByYear
        .map((ReservationsOfYear reservationsOfYear) => reservationsOfYear.year)
        .contains(currentReservation.departureDate.year)) {
      reservationsByYear.add(
        ReservationsOfYear(
          year: currentReservation.departureDate.year,
          reservations: <Reservation>[],
        ),
      );
    }

    if (currentReservation.arrivalDate.year ==
        currentReservation.departureDate.year) {
      reservationsByYear
          .where(
            (ReservationsOfYear element) =>
                element.year == currentReservation.departureDate.year,
          )
          .first
          .reservations
          .add(currentReservation);
    } else {
      final List<Reservation> splitReservations =
          reservationSplitOnYearChange(reservation: currentReservation);

      for (final Reservation splitReservation in splitReservations) {
        if (!reservationsByYear
            .map(
              (ReservationsOfYear reservationsOfYear) =>
                  reservationsOfYear.year,
            )
            .contains(splitReservation.departureDate.year)) {
          reservationsByYear.add(
            ReservationsOfYear(
              year: splitReservation.departureDate.year,
              reservations: <Reservation>[],
            ),
          );
        }

        reservationsByYear
            .where(
              (ReservationsOfYear element) =>
                  element.year == splitReservation.departureDate.year,
            )
            .firstOrNull
            ?.reservations
            .add(splitReservation);
      }
    }
  }
  return reservationsByYear;

  // { Year: [ reservations ],  }
}

class ReservationsOfYear {
  ReservationsOfYear({
    required this.year,
    required this.reservations,
  });

  final int year;
  final List<Reservation> reservations;
}

//? Why: Those are used for the analytics -
//? If you leave it as is, and sb reserves for 3 months, you will get 90 days on departureDateMonth..

List<Reservation> reservationSplitOnYearChange({
  required Reservation reservation,
}) {
  final DateTime departureDate = reservation.departureDate;
  final int departureYear = departureDate.year;

  final int arrivalYear = reservation.arrivalDate.year;
  final double averageDailyRate = reservation.dailyRate;

  if (arrivalYear == departureYear) {
    return <Reservation>[reservation];
  } else {
    final bool isCancelled = reservation.cancellationAmount != null;
    final List<Reservation> splitReservations = <Reservation>[];
    int hoursToAdd = DateTime(
      reservation.arrivalDate.year + 1,
      1,
      1,
      11,
    )
        .subtract(const Duration(days: 1))
        .difference(
          reservation.arrivalDate,
        )
        .inHours;

    //* keep the arrival date.
    Reservation currentReservation = reservation.copyWith(
      departureDate: reservation.arrivalDate.add(
        Duration(
          hours: hoursToAdd,
        ),
      ),
      payout: isCancelled
          ? 0
          : Duration(hours: hoursToAdd).inDays * averageDailyRate +
              averageDailyRate,
      cancellationAmount: isCancelled
          ? Duration(hours: hoursToAdd).inDays * averageDailyRate +
              averageDailyRate
          : null,
    );

    splitReservations.add(currentReservation);

    for (int currentYear = arrivalYear + 1;
        currentYear <= departureYear;
        currentYear++) {
      final DateTime currentArrivalDate = DateTime(currentYear, 1, 1, 13);
      hoursToAdd = min(
        DateTime(
          currentYear + 1,
          1,
          1,
          11,
        )
            .subtract(const Duration(days: 1))

            // .subtract(const Duration(days: 1))
            .difference(
              currentArrivalDate,
            )
            .inHours,
        reservation.departureDate
            .difference(
              currentArrivalDate,
            )
            .inHours,
      );

      final double correctedPayout =
          Duration(hours: hoursToAdd).inDays.round() * averageDailyRate +
              2 * averageDailyRate;

      currentReservation = reservation.copyWith(
        arrivalDate: currentArrivalDate,
        departureDate: currentArrivalDate.add(
          Duration(
            hours: hoursToAdd,
          ),
        ),
        payout: isCancelled ? 0 : correctedPayout,
        cancellationAmount: isCancelled ? correctedPayout : null,
      );

      splitReservations.add(currentReservation);
    }

    return splitReservations;
  }
}
