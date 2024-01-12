// ignore_for_file: avoid_print
import 'package:decla_time/core/documents_io/documents_io.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'setup_documents_directory.dart';


//use 'flutter test filename.dart'

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

    test("Read test file", () async{
      setUpDocumentsDirectoryForTesting();

      String randomText = "hello does this work?";
      await DocumentsIO.editReservationFile( "test", content: randomText);
      String fileContent = await DocumentsIO.readReservationFile("test");
      expect( fileContent, equals( randomText ) );
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

