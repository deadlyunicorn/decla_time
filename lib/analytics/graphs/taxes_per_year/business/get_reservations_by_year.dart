import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:provider/provider.dart";

Future<List<ReservationsOfYear>> getReservationsByYearFuture({
  required BuildContext context,
}) async {
  final Isar isar = await context.read<IsarHelper>().isarFuture;
  final List<Reservation> reservations = await isar.reservations
      .where()
      .findAll(); //TODO ?! doesn't work as intended unless we select desc. Debug it. !!!
  //TODO!!!!!!!!!!!!!
  int year = 0;
  final List<ReservationsOfYear> reservationsByYear = <ReservationsOfYear>[];
  for (int i = 0; i < reservations.length; i++) {
    final Reservation currentReservation = reservations[i];
    if (currentReservation.departureDate.year != year) {
      year = currentReservation.departureDate.year;
      reservationsByYear.add(
        ReservationsOfYear(
          year: year,
          reservations: <Reservation>[currentReservation],
        ),
      );
    } else {
      reservationsByYear
          .where((ReservationsOfYear element) => element.year == year)
          .first
          .reservations
          .add(currentReservation);
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
