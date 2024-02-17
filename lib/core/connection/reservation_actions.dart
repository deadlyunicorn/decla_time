import 'package:decla_time/reservations/reservation.dart';
import 'package:isar/isar.dart';

class ReservationActions {
  final Future<Isar> _isarFuture;
  final void Function() _notifyListeners;

  ReservationActions({required isarFuture, required notifyListeners})
      : _isarFuture = isarFuture,
        _notifyListeners = notifyListeners;

  Future<List<Reservation>> getAllEntriesFromReservations() async {
    return (await _isarFuture)
        .reservations
        .where()
        .sortByDepartureDateDesc()
        .findAll();
  }

  Future<void> removeFromDatabase(String reservationId) async {
    final isar = await _isarFuture;
    await isar.writeTxn(() async {
      await isar.reservations.deleteById(reservationId);
    });
    _notifyListeners();
  }

  Future<Iterable<Reservation>> filterRegistered(
      Iterable<Reservation> reservations) async {
    final Iterable<Reservation> databaseResponse = await (await _isarFuture)
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
        await (await _isarFuture).reservations.getById(
              id,
            );
    return databaseResponse != null;
  }

  Future<void> insertOrUpdateReservationEntry(Reservation reservation) async {
    final isar = await _isarFuture;

    await isar.writeTxn(() async {
      await isar.reservations.put(reservation);
    });
    _notifyListeners();
  }

  Future<Reservation?> getReservationEntry(String reservationId) async {
    final isar = await _isarFuture;
    return await isar.reservations
        .filter()
        .idEqualTo(reservationId)
        .findFirst();
  }

  Future<void> insertMultipleEntriesToDb(List<Reservation> reservations) async {
    final isar = await _isarFuture;

    await isar.writeTxn(() async {
      for (final reservation in reservations) {
        await isar.reservations.put(reservation);
      }
    });
    _notifyListeners();
  }
}