import 'package:flutter_test/flutter_test.dart';

import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/reservations/reservation.dart';
import 'package:decla_time/reservations/business/reservation_actions.dart';

import '../setup_documents_directory.dart';

void main() {
  setUpDocumentsDirectoryForTesting();

  test("Detecting Airbnb file", () async {
    final csvFileTable = await ReservationActions()
        .getRowEntriesFromCsvFile(
            'airbnb.csv'); //[0][1] => first row, second element of the row

    final columnCount = csvFileTable[0].length;
    expect(columnCount, 13);
  });

  test( "Testing Airbnb file constants mapping", ()async{
    
    final airbnbTable =
        await ReservationActions().getRowEntriesFromCsvFile(
      'airbnb.csv',
    );
    
    expect( airbnbTable[0][kAirbnbArrivalDateColumn], "Start date");
    expect( airbnbTable[0][kAirbnbDepartureDateColumn], "End date");
    expect( airbnbTable[0][kAirbnbGuestNameColumn], "Guest name");
    expect( airbnbTable[0][kAirbnbIdColumn], "Confirmation code");
    expect( airbnbTable[0][kAirbnbListingNameColumn], "Listing");
    expect( airbnbTable[0][kAirbnbPayoutColumn], "Earnings");
    expect( airbnbTable[0][kAirbnbReservationStatusColumn], "Status");


  });

  test( "Testing Booking.com file constants mapping", ()async{
    
    final bookingDotComTable =
        await ReservationActions().getRowEntriesFromCsvFile(
      'booking_gr_3.csv',
    );
    
    expect( bookingDotComTable[0][kBookingDotComArrivalDateColumn], "Check-in");
    expect( bookingDotComTable[0][kBookingDotComDepartureDateColumn], "Check-out");
    expect( bookingDotComTable[0][kBookingDotComGuestNameColumn], "Κράτηση από");
    expect( bookingDotComTable[0][kBookingDotComIdColumn], "Αριθμός κράτησης");
    expect( bookingDotComTable[0][kBookingDotComTotalPriceColumn], "Τιμή");
    expect( bookingDotComTable[0][kBookingDotComFeeColumn], "Ποσό προμήθειας");
    expect( bookingDotComTable[0][kBookingDotComReservationStatusColumn], "Κατάσταση");

  });

  test("Generating an Airbnb Table from an airbnb file", () async {


    List<Reservation> reservationsTable = await ReservationActions.generateReservationTableFromFile("airbnb.csv");

    //All files should have booking platform of Airbnb.
    expect(
      reservationsTable
          .where((element) => element.bookingPlatform != 'Airbnb')
          .length,
      0,
    );
  });

  test("Generating a BookingCom Table from a BookingDotCom file", () async {
    
    

    List<Reservation> reservationsTable = await ReservationActions.generateReservationTableFromFile(
      "booking_gr_3.csv"
    );

    


    //All files should have booking platform of Airbnb.
    expect(
        reservationsTable
            .where((element) => element.bookingPlatform != 'Booking.com')
            .length,
        0);
  });
}



