import 'package:decla_time/core/connection/reservation_actions.dart';
import 'package:decla_time/core/documents_io/documents_io.dart';
import 'package:decla_time/reservations/reservation.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

class IsarHelper extends ChangeNotifier {
  Future<Isar> get isarFuture async => Isar.instanceNames.isEmpty
      ? await Isar.open([ReservationSchema],
          directory: (await DocumentsIO.appDirFuture).path)
      : await Future.value(Isar.getInstance()!);

  //? The only bad thing about this design is that in the future
  //? if we change it - it will notify listeners from all the pages.

  //? however currently we remove the other pages that are not selected
  //? thus their listeners do not exist.

  //? This is basically a notifier that listens for all database changes..
  ReservationActions get reservationActions => ReservationActions(
        isarFuture: isarFuture,
        notifyListeners: notifyListeners,
      );
}
