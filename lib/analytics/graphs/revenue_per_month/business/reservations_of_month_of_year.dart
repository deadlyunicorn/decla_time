import "package:decla_time/reservations/reservation.dart";

class ReservationsOfMonthOfYear {
  final int year;
  final int month;
  final List<Reservation> reservations = <Reservation>[];

  ReservationsOfMonthOfYear({
    required this.year,
    required this.month,
  });

  double get monthTotal => reservations.fold(
        0,
        (double previousValue, Reservation reservation) =>
            previousValue +
            reservation.payout +
            (reservation.cancellationAmount ?? 0),
      );
}
