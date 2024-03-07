import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/enums/declaration_type.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
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

  Future<List<Declaration>> getAllDeclarationsByPropertyIdSorted({
    required String propertyId,
  }) async {
    return (await _isarFuture)
        .declarations
        .filter()
        .propertyIdEqualTo(propertyId)
        .sortByDepartureDateDesc()
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

  Future<int?> searchPageDeclarationAlreadyExists({
    required SearchPageDeclaration declaration,
    required String propertyId,
  }) async {
    return await declarationAlreadyExists(
      arrivalDate: declaration.arrivalDate,
      departureDate: declaration.departureDate,
      payout: declaration.payout,
      propertyId: propertyId,
      status: declaration.status,
      type: declaration.type,
      serialNumber: declaration.serialNumber,
    );
  }

  Future<int?> declarationAlreadyExists({
    required DateTime arrivalDate, //?Might have mistaken it - ammending
    required DateTime departureDate,
    required String propertyId,
    required double payout,
    required DeclarationStatus status,
    required DeclarationType type,
    required int? serialNumber,
  }) async {
    final Declaration? databaseResponse = await (await _isarFuture)
        .declarations
        .filter()
        .propertyIdEqualTo(propertyId)
        .declarationStatusEqualTo(status)
        .serialNumberEqualTo(serialNumber)
        .payoutEqualTo(payout)
        .arrivalDateEqualTo(arrivalDate)
        .departureDateEqualTo(departureDate)
        .findFirst();

    return databaseResponse?.isarId;
    //? Issue: property has 2 reservations of the same payout and departureDate.
    //? This should not be an issue for our target audience.. ( not hotels )
  }

  Future<void> insertOrUpdateDeclarationEntry(Declaration declaration) async {
    final Isar isar = await _isarFuture;

    await isar.writeTxn(() async {
      await isar.declarations.put(declaration);
    });
    _notifyListeners();
  }

  Future<Declaration?> getDeclarationEntryByIsarId(
    int isarId,
  ) async {
    final Isar isar = await _isarFuture;
    return await isar.declarations.filter().isarIdEqualTo(isarId).findFirst();
  }

  Future<Declaration?> getDeclarationEntryByDeclarationDbId(
    int declarationDbId,
  ) async {
    final Isar isar = await _isarFuture;
    return await isar.declarations
        .filter()
        .declarationDbIdEqualTo(declarationDbId)
        .findFirst();
  }

  Future<List<int>> insertMultipleEntriesToDb(
    List<Declaration> declarations,
  ) async {
    final Isar isar = await _isarFuture;
    List<int> idsOfInsertedItems = <int>[];

    await isar.writeTxn(() async {
      for (final Declaration declaration in declarations) {
        idsOfInsertedItems.add(await isar.declarations.put(declaration));
      }
    });
    _notifyListeners();
    return idsOfInsertedItems;
  }

  Future<List<int>> insertMultipleFinalizedDeclarationsToDb(
    List<FinalizedDeclarationDetails> listOfDetails,
  ) async {
    final Isar isar = await _isarFuture;
    List<int> idsOfInsertedItems = <int>[];

    await isar.writeTxn(() async {
      for (final FinalizedDeclarationDetails declarationDetails
          in listOfDetails) {
        idsOfInsertedItems.add(
          await isar.finalizedDeclarationDetails.put(declarationDetails),
        );
      }
    });
    _notifyListeners();
    return idsOfInsertedItems;
  }

  Future<FinalizedDeclarationDetails?>
      getFinalizedDeclarationDetailsByDeclarationDbId(
    int declarationDbId,
  ) async {
    final Isar isar = await _isarFuture;
    return await isar.finalizedDeclarationDetails
        .filter()
        .declarationDbIdEqualTo(declarationDbId)
        .findFirst();
  }
}
