import 'package:decla_time/reservations/business/reservation_actions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../setup_documents_directory.dart';

void main(){

  setUpDocumentsDirectoryForTesting();

  test( "Testing something", () async{

    final reservations = await ReservationActions().generateReservationTableFromAllCsvFilesInReservationsDirectory() ;
    final totalFromFiles = reservations.fold<double>( 0, ( previousValue , element) => previousValue + ( element.payout / (( element.departureDate.difference( element.arrivalDate ) ).inDays + 1 ) )); //Guest checks in at 1PM and checks out at 11AM. inDays() will return 0 for 1 a stay of 1 day - we need to add 1.

    // ignore: avoid_print
    print( "Your average is ${totalFromFiles/reservations.length}");
  });
}