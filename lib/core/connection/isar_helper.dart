import 'package:decla_time/core/documents_io/documents_io.dart';
import 'package:decla_time/reservations/reservation.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

class IsarHelper extends ChangeNotifier {
  Future<Isar> get isarFuture async => Isar.instanceNames.isEmpty
      ? await Isar.open([ReservationSchema],
          directory: (await DocumentsIO.appDirFuture).path)
      : await Future.value(Isar.getInstance()!);

  Future<List<Reservation>> getAllEntriesFromReservations() async {
    return (await isarFuture)
        .reservations
        .where()
        .sortByDepartureDateDesc()
        .findAll();
  }

  Future<void> removeFromDatabase( String reservationId ) async{
    
    final isar = await isarFuture;
    await isar.writeTxn(() async{
      await isar.reservations.deleteById( reservationId );
    });
    notifyListeners();
  }

  Future<Iterable<Reservation>> filterRegistered(
      Iterable<Reservation> reservations) async {
    final Iterable<Reservation> databaseResponse = await (await isarFuture)
        .reservations
        .getAllById(
          reservations.map((reservation) => reservation.id).toList(),
        )
        .then(
          (databaseReservations) => databaseReservations.nonNulls,
        );
    return databaseResponse;
  }

  Future<bool> idAlreadyExists(String id) async {
    final Reservation? databaseResponse =
        await (await isarFuture).reservations.getById(
              id,
            );
    return databaseResponse != null;
  }

  Future<void> insertOrUpdateReservationEntry(Reservation reservation) async {
    final isar = await isarFuture;

    await isar.writeTxn(() async {
      await isar.reservations.put(reservation);
    });
    notifyListeners();
  }

  Future<Reservation?> getReservationEntry(String reservationId) async {
    final isar = await isarFuture;
    return await isar.reservations
        .filter()
        .idEqualTo(reservationId)
        .findFirst();
  }

  Future<void> insertMultipleEntriesToDb(List<Reservation> reservations) async {
    final isar = await isarFuture;

    await isar.writeTxn(() async {
      for (final reservation in reservations) {
        await isar.reservations.put(reservation);
      }
    });
    notifyListeners();
  }
}
