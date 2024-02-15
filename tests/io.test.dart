import 'package:decla_time/core/documents_io/documents_io.dart';
import 'package:flutter_test/flutter_test.dart';

import 'setup_documents_directory.dart';


void main() {

  group( "Reservations Folder Manipulation", () {

    test('Creating test file in the reservations directory', () async {

      setUpDocumentsDirectoryForTesting();
      
      await DocumentsIO.createReservationFile("test");
      int fileCount = (await DocumentsIO.reservationsDirectoryFuture ).listSync().length;
      expect(
        fileCount, equals(1) 
      );

    });

    test("Delete test file", () async{
      setUpDocumentsDirectoryForTesting();

      await DocumentsIO.deleteReservationFile("test");
      int fileCount = (await DocumentsIO.reservationsDirectoryFuture ).listSync().length;
      expect(
        fileCount, equals(0) 
      );
    });

  });
  

}

