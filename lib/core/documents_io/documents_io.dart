
import 'dart:io';

import 'package:decla_time/core/constants/constants.dart';
import 'package:path_provider/path_provider.dart';

class DocumentsIO {

  static final _documentsDirectoryFuture = getApplicationDocumentsDirectory();

  static final Future<Directory> appDirFuture = _documentsDirectoryFuture
    .then(( documentsDirectory ){

      final appDir = "${documentsDirectory.path}/$kApplicationName";

      return Directory(appDir)
        .exists()
        .then( ( doesExist ) async {
          return doesExist
          ? Directory( appDir )  
          : await Directory( appDir ).create(); 
        });
      
    });

  static final Future<Directory> reservationsDirectoryFuture = appDirFuture.then(
    ( appDirectory ) {
      final reservationsDirectory = "${appDirectory.path}/reservations";
      return Directory( reservationsDirectory )
        .exists()
        .then( ( doesExist ) async {
          return doesExist
            ? Directory( reservationsDirectory ) 
            : await Directory( reservationsDirectory ).create( recursive: true );
        });
    }
  );

  static Future<File> createReservationFile( String filename ) async {
    
    final reservationsDirectory = await reservationsDirectoryFuture;
    return File( "${reservationsDirectory.path}/$filename" ).create();
  }

  static Future<void> deleteReservationFile( String filename ) async {
    
    final reservationsDirectory = await reservationsDirectoryFuture;
    File( "${reservationsDirectory.path}/$filename" ).delete();
  }

  static Future<void> editReservationFile( String filename, {
    required String content
  } ) async {
    final reservationsDirectory = await reservationsDirectoryFuture;
    File( "${reservationsDirectory.path}/$filename" ).writeAsString( content );
  }

  /// Reads the file and exports the text as STRING.
  // static Future<String> readReservationFile( String filename ) async {
  //   final reservationsDirectory = await reservationsDirectoryFuture;
  //   return File( "${reservationsDirectory.path}/$filename" ).readAsString();
  // }


}