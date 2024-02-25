import "dart:async";
import "dart:io";

import "package:decla_time/core/constants/constants.dart";
import "package:path_provider/path_provider.dart";

class DocumentsIO {
  static final Future<Directory> _documentsDirectoryFuture =
      getApplicationDocumentsDirectory();

  static final Future<Directory> appDirFuture =
      _documentsDirectoryFuture.then((Directory documentsDirectory) async {
    final String appDir = "${documentsDirectory.path}/$kApplicationName";

    return Directory(appDir).existsSync()
        ? Directory(appDir)
        : await Directory(appDir).create();
  });

  static final Future<Directory> reservationsDirectoryFuture =
      appDirFuture.then((Directory appDirectory) async {
    final String reservationsDirectory = "${appDirectory.path}/reservations";
    return Directory(reservationsDirectory).existsSync()
        ? Directory(reservationsDirectory)
        : await Directory(reservationsDirectory).create(recursive: true);
  });

  static Future<File> createReservationFile(String filename) async {
    final Directory reservationsDirectory = await reservationsDirectoryFuture;
    return File("${reservationsDirectory.path}/$filename").create();
  }

  static Future<void> deleteReservationFile(String filename) async {
    final Directory reservationsDirectory = await reservationsDirectoryFuture;
    unawaited(File("${reservationsDirectory.path}/$filename").delete());
  }

  static Future<void> editReservationFile(
    String filename, {
    required String content,
  }) async {
    final Directory reservationsDirectory = await reservationsDirectoryFuture;
    unawaited(
      File("${reservationsDirectory.path}/$filename").writeAsString(content),
    );
  }

  /// Reads the file and exports the text as STRING.
  // static Future<String> readReservationFile( String filename ) async {
  //   final reservationsDirectory = await reservationsDirectoryFuture;
  //   return File( "${reservationsDirectory.path}/$filename" ).readAsString();
  // }
}
