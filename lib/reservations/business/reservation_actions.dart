import 'dart:io';

import 'package:intl/intl.dart';

import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/documents_io/documents_io.dart';
import 'package:decla_time/core/errors/exceptions.dart';
import 'package:decla_time/reservations/business/reservation.dart';

class ReservationFolderActions {


  Future<List<List<String>>> getRowEntriesFromCsvFile(String fileName) async {
    final reservationFileContent =
        (await DocumentsIO.readReservationFile(fileName)).toString();
    final csvFileRows = reservationFileContent.split('\n');
    return csvFileRows.map((rowString) => rowString.split(',')).map((rowList) {
      return rowList.map((rowEntry) => rowEntry.replaceAll("\"", "")).toList();
    }).toList();
  }

  static Map<int, Map<int, List<Reservation>>> genereateYearMonthMap( List<Reservation> reservations){

    Map<int, Map<int, List<Reservation>>> tempMap = {};
    

    for ( final  reservation in reservations) {

      final yearOfReservation = reservation.departureDate.year;
      final monthOfReservation = reservation.departureDate.month;
      final existingReservationsOfTheMonth = tempMap[yearOfReservation]?[monthOfReservation] ?? [];

      tempMap.addAll({
        yearOfReservation: {
          ...( tempMap[yearOfReservation] ?? {} ), //The already existing or a new year map
          monthOfReservation: [
            ...existingReservationsOfTheMonth,
            reservation
          ]
        }
      });
    }

    //2023: {  }

    return tempMap;
  }

  Future<List<Reservation>> generateReservationTableFromAllCsvFilesInReservationsDirectory( ) async {

    final reservationCsvFileNames =
        (await ReservationFolderActions._listReservationFiles())
            .where((file) => file.path.contains(".csv"))
            .map((file) => file.path.substring(file.path.lastIndexOf("/")));

    final reservationsTable = (await Future.wait(reservationCsvFileNames
            .map((filename) => (generateReservationTableFromFile(filename)))))
            .fold<List<Reservation>>( [], (previousValue, element) => [...previousValue, ...element]);

    // .fold( [] as List<Reservation>, (previousValue, element) async => [ ...previousValue, ...(await element) ]);

    return reservationsTable;
  }

  Future<List<Reservation>> generateReservationTableFromMultipleFiles( List<File> files) async{
    
    final reservationsTable = (await Future.wait( files
            .map((filename) => (generateReservationTableFromFile( filename.path )))))
            .fold<List<Reservation>>( [], (previousValue, element) => [...previousValue, ...element]);

    // .fold( [] as List<Reservation>, (previousValue, element) async => [ ...previousValue, ...(await element) ]);

    return reservationsTable;
  }

  static Future<List<File>> _listReservationFiles() async {
    return (await DocumentsIO.reservationsDirectoryFuture)
        .listSync()
        .whereType<File>()
        .toList();
  }

  void deleteReservationFile() {
    //User can delete a file
  }

  void deleteMultipleReservationFiles() {
    //User can select files to delete.
  }

  static Future<List<Reservation>> generateReservationTableFromFile(
      String filename) async {
    final tableFromCsvFile =
        await ReservationFolderActions().getRowEntriesFromCsvFile(
      filename,
    ); //[0][1] => first row, second element of the row;

    if (tableFromCsvFile[0].length == 13) {
      //File is Airbnb File
      return ReservationFolderActions._generateReservationTableFromAirbnbFile(
          tableFromCsvFile);
    } else if (tableFromCsvFile[0].length == 19 ||
        tableFromCsvFile[0].length == 20) {
      //File is Booking File
      //the columns aren't correctly built ( "Reservation by" names get split into 2 columns, thus getting 20 if it's not the first row).

      return ReservationFolderActions
          ._generateReservationTableFromBookingDotComFile(tableFromCsvFile);
    } else {
      throw UnsupportedFileException();
    }
  }

  static List<Reservation> _generateReservationTableFromAirbnbFile(
      List<List<String>> csvFileRowEntries) {
    List<Reservation> airbnbTable = [];

    for (int i = 0; i < csvFileRowEntries.length; i++) {
      if (csvFileRowEntries[i].length != 13) break; //Last row

      List<String> hostPayoutString = [];
      {
        final payoutEntry = csvFileRowEntries[i][kAirbnbPayoutColumn];
        for (int j = 0; j < payoutEntry.length; j++) {
          final currentCharacter = payoutEntry[j];
          if (int.tryParse(currentCharacter) != null ||
              currentCharacter == ".") {
            hostPayoutString.add(currentCharacter);
          }
        }
      }

      if (hostPayoutString.isEmpty) {
        //in case i == 0 it is a column header.
        if (i > 0) throw UnsupportedFileException();
      } else {
        airbnbTable.add(
          Reservation(
            bookingPlatform: "Airbnb",
            listingName: csvFileRowEntries[i][kAirbnbListingNameColumn],
            id: csvFileRowEntries[i][kAirbnbIdColumn],
            guestName: csvFileRowEntries[i][kAirbnbGuestNameColumn],
            arrivalDate: DateFormat('M/d/y HH:mm').parse(
                "${csvFileRowEntries[i][kAirbnbArrivalDateColumn]} 13:00"),
            departureDate: DateFormat('M/d/y HH:mm').parse(
                "${csvFileRowEntries[i][kAirbnbDepartureDateColumn]} 09:00"),
            payout: double.parse(hostPayoutString.join('')),
            reservationStatus: csvFileRowEntries[i]
                [kAirbnbReservationStatusColumn],
          ),
        );
      }
    }
    return airbnbTable;
  }

  static List<Reservation> _generateReservationTableFromBookingDotComFile(
    List<List<String>> csvFileRowEntries,
  ) {
    csvFileRowEntries = csvFileRowEntries
        .where((row) => (row.length == 19) || (row.length == 20))
        .map((row) => row.length > 18 ? row.getRange(0, 18).toList() : row)
        .toList();

    List<Reservation> bookingDotComTable = [];

    for (int i = 0; i < csvFileRowEntries.length; i++) {
      // print( "====================");
      // print( "Entry Number $i");
      // print( "====================");

      // for ( int j = 0; j < csvFileRowEntries[i].length; j++ ){
      //   print( "$j : ${csvFileRowEntries[i][j]}" );
      // }

      {
        // "Reservation by" names get split into 2 columns for some reason.. This fixes it
        csvFileRowEntries[i][1] =
            csvFileRowEntries[i][1] + csvFileRowEntries[i][2];
        csvFileRowEntries[i].removeAt(2);
      }
      // if (csvFileRowEntries[i].length != 18) break; //Last row

      List<String> totalPriceString = [];
      List<String> totalFeeString = [];

      {
        //Getting the price values
        final totalPriceEntry =
            csvFileRowEntries[i][kBookingDotComTotalPriceColumn];
        for (int j = 0; j < totalPriceEntry.length; j++) {
          final currentCharacter = totalPriceEntry[j];
          if (int.tryParse(currentCharacter) != null ||
              currentCharacter == ".") {
            totalPriceString.add(currentCharacter);
          }
        }
        final totalFeeEntry = csvFileRowEntries[i][kBookingDotComFeeColumn];
        for (int j = 0; j < totalFeeEntry.length; j++) {
          final currentCharacter = totalFeeEntry[j];
          if (int.tryParse(currentCharacter) != null ||
              currentCharacter == ".") {
            totalFeeString.add(currentCharacter);
          }
        }
      }

      if (totalPriceString.isEmpty) {
        //in case i == 0 it is a column header.
        if (i > 0) throw UnsupportedFileException();
      } else {
        double hostPayout = double.parse(
            (double.parse(totalPriceString.join('')) -
                    (double.tryParse(totalFeeString.join('')) ?? 0))
                .toStringAsFixed(2));

        bookingDotComTable.add(
          Reservation(
            bookingPlatform: "Booking.com",
            listingName: null,
            id: csvFileRowEntries[i][kBookingDotComIdColumn],
            guestName: csvFileRowEntries[i][kBookingDotComGuestNameColumn],
            arrivalDate: DateFormat('y-MM-dd HH:mm').parse(
                "${csvFileRowEntries[i][kBookingDotComArrivalDateColumn]} 13:00"),
            departureDate: DateFormat('y-MM-dd HH:mm').parse(
                "${csvFileRowEntries[i][kBookingDotComDepartureDateColumn]} 09:00"),
            payout: hostPayout,
            reservationStatus: csvFileRowEntries[i]
                [kBookingDotComReservationStatusColumn],
          ),
        );
      }
    }
    return bookingDotComTable;
  }
}
