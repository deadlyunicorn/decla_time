import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/business/reservation_actions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'setup_documents_directory.dart';


void main() async{

  await Isar.initializeIsarCore( download: true);
  setUpDocumentsDirectoryForTesting();

  group( "Reservations Folder Manipulation", () {

     

    test('Adding to database and reading database entries', () async {

      final newReservation = Reservation(
        arrivalDate: DateTime.now(),
        bookingPlatform: "Airbnb",
        departureDate: DateTime( 2024 ),
        guestName: "John Doe",
        id: "AABBCC",
        listingName: "Lovely",
        payout: 377.42,
        reservationStatus: "ok",
      );

      await IsarHelper().insertOrUpdateReservationEntry(newReservation);
      final reservationInDb = await IsarHelper().getReservationEntry( newReservation.id );
      expect( reservationInDb?.guestName, newReservation.guestName);
    });

    test('Inserting entries from a file', () async {

      final isar = await IsarHelper().isarFuture;

      await isar.writeTxn(()async { //deleting all entries
        final dbEntries = (await isar.reservations.where().findAll()).map((reservation) => reservation.isarId).toList();

        await isar.reservations.deleteAll(dbEntries);
        // await isar.reservations.clear();

      });

      expect( await isar.reservations.count(), 0);

      final entries = await ReservationActions.generateReservationTableFromFile(
      "booking_gr_3.csv"
      );

      await IsarHelper().insertMultipleEntriesToDb(
        entries
      );

      
      expect( await isar.reservations.count(), greaterThan( 1 ));
    });
  });
}
