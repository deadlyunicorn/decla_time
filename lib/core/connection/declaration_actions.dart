import "package:decla_time/declarations/database/declaration.dart";
import "package:isar/isar.dart";

class DeclarationActions {
  final Future<Isar> _isarFuture;
  final void Function() _notifyListeners;

  DeclarationActions({
    required Future<Isar> isarFuture,
    required void Function() notifyListeners,
  })  : _isarFuture = isarFuture,
        _notifyListeners = notifyListeners;

  Future<List<Declaration>> getAllDeclarationsFrom({
    required String propertyId,
  }) async {
    return (await _isarFuture)
        .declarations
        .filter()
        .propertyIdEqualTo(propertyId)
        .findAll();
  }

  Future<List<Declaration>> getAllEntriesFromDeclarations() async {
    return (await _isarFuture)
        .declarations
        .where()
        .sortByDepartureDateDesc()
        .findAll();
  }

  Future<void> removeFromDatabase(int declarationDbId) async {
    final Isar isar = await _isarFuture;
    await isar.writeTxn(() async {
      await isar.declarations.deleteByDeclarationDbId(declarationDbId);
    });
    _notifyListeners();
  }

  // Future<Iterable<Declaration>> filterRegistered(
  //     Iterable<Declaration> declarations) async {
  //   final Iterable<Declaration> databaseResponse = await (await _isarFuture)
  //       .declarations
  //       .getAllById(
  //         declarations.map((reservation) => reservation.id).toList(),
  //       )
  //       .then(
  //         (databaseDeclarations) => databaseDeclarations.nonNulls,
  //       );
  //   return databaseResponse;
  // }

  Future<bool> declarationAlreadyExists(int declarationDbId) async {
    final Declaration? databaseResponse =
        await (await _isarFuture).declarations.getByDeclarationDbId(
              declarationDbId,
            );
    return databaseResponse != null;
  }

  Future<void> insertOrUpdateDeclarationEntry(Declaration declaration) async {
    final Isar isar = await _isarFuture;

    await isar.writeTxn(() async {
      await isar.declarations.put(declaration);
    });
    _notifyListeners();
  }

  Future<Declaration?> getDeclarationEntry(int declarationDbId) async {
    final Isar isar = await _isarFuture;
    return await isar.declarations
        .filter()
        .declarationDbIdEqualTo(declarationDbId)
        .findFirst();
  }

  Future<void> insertMultipleEntriesToDb(List<Declaration> declarations) async {
    final Isar isar = await _isarFuture;

    await isar.writeTxn(() async {
      for (final Declaration declaration in declarations) {
        await isar.declarations.put(declaration);
      }
    });
    _notifyListeners();
  }
}
