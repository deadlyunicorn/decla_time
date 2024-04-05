import "dart:io";

import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/documents_io/documents_io.dart";
import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:intl/intl.dart";

class ReservationActions {
  Future<List<List<String>>> getRowEntriesFromCsvFile(String path) async {
    final String reservationFileContent = await File(path).readAsString();
    final List<String> csvFileRows = reservationFileContent.split("\n");
    return csvFileRows
        .map((String rowString) => rowString.split(","))
        .map((List<String> rowList) {
      return rowList
          .map((String rowEntry) => rowEntry.replaceAll("\"", ""))
          .toList();
    }).toList();
  }

  static Map<int, Map<int, List<Reservation>>> genereateYearMonthMap(
    List<Reservation> reservations,
  ) {
    Map<int, Map<int, List<Reservation>>> tempMap =
        <int, Map<int, List<Reservation>>>{};

    for (final Reservation reservation in reservations) {
      final int yearOfReservation = reservation.departureDate.year;
      final int monthOfReservation = reservation.departureDate.month;
      final List<Reservation> existingReservationsOfTheMonth =
          tempMap[yearOfReservation]?[monthOfReservation] ?? <Reservation>[];

      tempMap.addAll(<int, Map<int, List<Reservation>>>{
        yearOfReservation: <int, List<Reservation>>{
          ...(tempMap[yearOfReservation] ??
              <int,
                  List<
                      Reservation>>{}), //The already existing or a new year map
          monthOfReservation: <Reservation>[
            ...existingReservationsOfTheMonth,
            reservation,
          ],
        },
      });
    }

    //2023: {  }

    return tempMap;
  }

  Future<List<Reservation>>
      generateReservationTableFromAllCsvFilesInReservationsDirectory() async {
    final Iterable<String> reservationCsvFileNames =
        (await ReservationActions._listReservationFiles())
            .where((File file) => file.path.contains(".csv"))
            .map(
              (File file) => file.path.substring(file.path.lastIndexOf("/")),
            );

    final List<Reservation> reservationsTable = (await Future.wait(
      reservationCsvFileNames.map(
        (String filename) => (generateReservationTableFromFile(filename)),
      ),
    ))
        .fold<List<Reservation>>(
      <Reservation>[],
      (List<Reservation> previousValue, List<Reservation> element) =>
          <Reservation>[...previousValue, ...element],
    );

    // .fold( [] as List<Reservation>, (previousValue, element)
    // async => [ ...previousValue, ...(await element) ]);

    return reservationsTable;
  }

  static Future<List<Reservation>> generateReservationTableFromMultipleFiles(
    List<File> files,
  ) async {
    final List<Reservation> reservationsTable = (await Future.wait(
      files.map(
        (File filename) => (generateReservationTableFromFile(filename.path)),
      ),
    ))
        .fold<List<Reservation>>(
      <Reservation>[],
      (List<Reservation> previousValue, List<Reservation> element) =>
          <Reservation>[...previousValue, ...element],
    );

    // .fold( [] as List<Reservation>, (previousValue, element) async =>
    //[ ...previousValue, ...(await element) ]);

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
    String filename,
  ) async {
    final List<List<String>> tableFromCsvFile =
        await ReservationActions().getRowEntriesFromCsvFile(
      filename,
    ); //[0][1] => first row, second element of the row;

    if (tableFromCsvFile[0].length == 13) {
      //File is Airbnb File
      return ReservationActions._generateReservationTableFromAirbnbFile(
        tableFromCsvFile,
      );
    } else if (tableFromCsvFile[0].length == 19 ||
        tableFromCsvFile[0].length == 20) {
      //File is Booking File
      //the columns aren't correctly built
      // ( "Reservation by" names get split into 2 columns, thus getting 20
      // if it's not the first row).

      return ReservationActions._generateReservationTableFromBookingDotComFile(
        tableFromCsvFile,
      );
    } else {
      throw UnsupportedFileException();
    }
  }

  static List<Reservation> _generateReservationTableFromAirbnbFile(
    List<List<String>> csvFileRowEntries,
  ) {
    List<Reservation> airbnbTable = <Reservation>[];

    for (int i = 0; i < csvFileRowEntries.length; i++) {
      if (csvFileRowEntries[i].length != 13) break; //Last row

      List<String> hostPayoutString = <String>[];
      {
        final String payoutEntry = csvFileRowEntries[i][kAirbnbPayoutColumn];
        for (int j = 0; j < payoutEntry.length; j++) {
          final String currentCharacter = payoutEntry[j];
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
            cancellationAmount: null, //TODO UNIMPLEMENTED
            cancellationDate: null, //TODO UNIMPLEMENTED
            bookingPlatform: "Airbnb",
            listingName: csvFileRowEntries[i][kAirbnbListingNameColumn],
            id: csvFileRowEntries[i][kAirbnbIdColumn],
            guestName: csvFileRowEntries[i][kAirbnbGuestNameColumn],
            arrivalDate: DateFormat("M/d/y HH:mm").parse(
              "${csvFileRowEntries[i][kAirbnbArrivalDateColumn]} 13:00",
            ),
            departureDate: DateFormat("M/d/y HH:mm").parse(
              "${csvFileRowEntries[i][kAirbnbDepartureDateColumn]} 11:00",
            ),
            payout: double.parse(hostPayoutString.join("")),
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
        .where((List<String> row) => (row.length == 19) || (row.length == 20))
        .map(
          (List<String> row) =>
              row.length > 18 ? row.getRange(0, 18).toList() : row,
        )
        .toList();

    List<Reservation> bookingDotComTable = <Reservation>[];

    for (int i = 0; i < csvFileRowEntries.length; i++) {
      // print( "====================");
      // print( "Entry Number $i");
      // print( "====================");

      // for ( int j = 0; j < csvFileRowEntries[i].length; j++ ){
      //   print( "$j : ${csvFileRowEntries[i][j]}" );
      // }

      {
        // "Reservation by" names get split into 2 columns for some reason..
        //This fixes it
        csvFileRowEntries[i][1] =
            csvFileRowEntries[i][1] + csvFileRowEntries[i][2];
        csvFileRowEntries[i].removeAt(2);
      }
      // if (csvFileRowEntries[i].length != 18) break; //Last row

      List<String> totalPriceString = <String>[];
      List<String> totalFeeString = <String>[];

      {
        //Getting the price values
        final String totalPriceEntry =
            csvFileRowEntries[i][kBookingDotComTotalPriceColumn];
        for (int j = 0; j < totalPriceEntry.length; j++) {
          final String currentCharacter = totalPriceEntry[j];
          if (int.tryParse(currentCharacter) != null ||
              currentCharacter == ".") {
            totalPriceString.add(currentCharacter);
          }
        }
        final String totalFeeEntry =
            csvFileRowEntries[i][kBookingDotComFeeColumn];
        for (int j = 0; j < totalFeeEntry.length; j++) {
          final String currentCharacter = totalFeeEntry[j];
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
          (double.parse(totalPriceString.join("")) -
                  (double.tryParse(totalFeeString.join("")) ?? 0))
              .toStringAsFixed(2),
        );

        bookingDotComTable.add(
          Reservation(
            cancellationDate: null, //TODO UNIMPLEMENTED
            cancellationAmount: null, //TODO UNIMPLEMENTED
            bookingPlatform: "Booking.com",
            listingName: null,
            id: csvFileRowEntries[i][kBookingDotComIdColumn],
            guestName: csvFileRowEntries[i][kBookingDotComGuestNameColumn],
            arrivalDate: DateFormat("y-MM-dd HH:mm").parse(
              "${csvFileRowEntries[i][kBookingDotComArrivalDateColumn]} 13:00",
            ),
            departureDate: DateFormat("y-MM-dd HH:mm").parse(
              // ignore: lines_longer_than_80_chars
              "${csvFileRowEntries[i][kBookingDotComDepartureDateColumn]} 11:00",
            ),
            payout: hostPayout,
            reservationStatus: csvFileRowEntries[i]
                [kBookingDotComReservationStatusColumn],
          ),
        );
      }
    }
    return bookingDotComTable;
  }

  static Iterable<Reservation> filterReservations(
    Iterable<Reservation> reservations,
    Iterable<Reservation> reservationsToExclude,
  ) {
    final Set<String> alreadyFoundIds = reservationsToExclude
        .map((Reservation reservation) => reservation.id)
        .toSet();

    final Iterable<Reservation> newReservationEntries = reservations.where(
      //make sure we don't add duplicates
      (Reservation reservation) => !alreadyFoundIds.contains(reservation.id),
    );

    return newReservationEntries;
  }
}
