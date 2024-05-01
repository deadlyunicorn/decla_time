import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/enums/booking_platform.dart";
import "package:decla_time/reservations/business/reservation_actions.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter_test/flutter_test.dart";
import "package:isar/isar.dart";

import "setup_documents_directory.dart";

void main() async {
  await Isar.initializeIsarCore(download: true);
  setUpDocumentsDirectoryForTesting();

  group("Reservations Folder Manipulation", () {
    test("Adding to database and reading database entries", () async {
      final Reservation newReservation = Reservation(
        cancellationDate: null,
        cancellationAmount: null,
        arrivalDate: DateTime.now(),
        bookingPlatform: BookingPlatform.airbnb,
        departureDate: DateTime(2024),
        guestName: "John Doe",
        id: "AABBCC",
        listingName: "Lovely",
        payout: 377.42,
        reservationStatus: "ok",
        reservationPlaceId: 1,
      );

      await IsarHelper()
          .reservationActions
          .insertOrUpdateReservationEntry(newReservation);
      final Reservation? reservationInDb = await IsarHelper()
          .reservationActions
          .getReservationEntry(newReservation.id);
      expect(reservationInDb?.guestName, newReservation.guestName);
    });

    test("Inserting entries from a file", () async {
      final Isar isar = await IsarHelper().isarFuture;

      await isar.writeTxn(() async {
        //deleting all entries
        final List<Id> dbEntries = (await isar.reservations.where().findAll())
            .map((Reservation reservation) => reservation.isarId)
            .toList();

        await isar.reservations.deleteAll(dbEntries);
        // await isar.reservations.clear();
      });

      expect(await isar.reservations.count(), 0);

      final List<Reservation> entries =
          await ReservationActions.generateReservationTableFromFile(
        "booking_gr_3.csv",
      );

      await IsarHelper().reservationActions.insertMultipleEntriesToDb(
            entries,
          );

      expect(await isar.reservations.count(), greaterThan(1));
    });
  });
}
