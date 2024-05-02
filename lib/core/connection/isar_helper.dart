import "package:decla_time/core/connection/declaration_actions.dart";
import "package:decla_time/core/connection/reservation_actions.dart";
import "package:decla_time/core/connection/user_actions.dart";
import "package:decla_time/core/documents_io/documents_io.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/database/user/user.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:decla_time/reservations/reservation_place.dart";
import "package:flutter/foundation.dart";
import "package:isar/isar.dart";

class IsarHelper extends ChangeNotifier {
  Future<Isar> get isarFuture async => Isar.instanceNames.isEmpty
      ? await Isar.open(
          <CollectionSchema<Object>>[
            ReservationSchema,
            ReservationPlaceSchema,
            DeclarationSchema,
            FinalizedDeclarationDetailsSchema,
            UserPropertySchema,
            UserSchema,
          ],
          directory: (await DocumentsIO.appDirFuture).path,
        )
      : await Future<Isar>.value(Isar.getInstance()!);

  ReservationActions? _reservationActions;
  DeclarationActions? _declarationActions;
  UserActions? _userActions;
  ReservationPlaceActions? _reservationPlaceActions;

  //? The only bad thing about this design is that in the future
  //? if we change it - it will notify listeners from all the pages.

  //? however currently we remove the other pages that are not selected
  //? thus their listeners do not exist.

  //? This is basically a notifier that listens for all database changes..
  ReservationActions get reservationActions {
    final ReservationActions initializedReservationActions =
        _reservationActions ??
            ReservationActions(
              isarFuture: isarFuture,
              notifyListeners: notifyListeners,
            );
    _reservationActions ??= initializedReservationActions;
    return initializedReservationActions;
  }

  DeclarationActions get declarationActions {
    final DeclarationActions initializedDeclarationActions =
        _declarationActions ??
            DeclarationActions(
              isarFuture: isarFuture,
              notifyListeners: notifyListeners,
            );
    _declarationActions ??= initializedDeclarationActions;
    return initializedDeclarationActions;
  }

  UserActions get userActions {
    final UserActions initializedUserActions = _userActions ??
        UserActions(
          isarFuture: isarFuture,
          notifyListeners: notifyListeners,
        );
    _userActions ??= initializedUserActions;
    return initializedUserActions;
  }

  ReservationPlaceActions get reservationPlaceActions {
    final ReservationPlaceActions reservationPlaceActions =
        _reservationPlaceActions ??
            ReservationPlaceActions(
              isarFuture: isarFuture,
              notifyListeners: notifyListeners,
            );
    _reservationPlaceActions ??= reservationPlaceActions;
    return reservationPlaceActions;
  }

  void update() {
    notifyListeners();
  }
}

class ReservationPlaceActions {
  ReservationPlaceActions({
    required Future<Isar> isarFuture,
    required void Function() notifyListeners,
  })  : _isarFuture = isarFuture,
        _notifyListeners = notifyListeners;

  final Future<Isar> _isarFuture;
  final void Function() _notifyListeners;

  Future<void> putReservationPlace(String friendlyName) async {
    final Isar isar = await _isarFuture;
    await isar.writeTxn(() async {
      await isar.reservationPlaces.put(
        ReservationPlace(
          friendlyName: friendlyName,
        ),
      );
    });
    _notifyListeners();
  }
}
