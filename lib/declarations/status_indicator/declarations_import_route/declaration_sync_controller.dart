import "dart:async";

import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/enums/booking_platform.dart";
import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/status_indicator/declaration_status.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_details_from_search_page_data.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_search_page.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/search_page_data.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
import "package:flutter/material.dart";

class DeclarationSyncController extends ChangeNotifier {
  bool _requestNewImportSession = false;
  bool _isProcessing = false;
  void setIsImporting(bool newState) {
    _isProcessing = newState;
    notifyListeners();
  }

  final IsarHelper _isarHelper;
  DeclarationSyncController({
    required IsarHelper isarHelper,
  }) : _isarHelper = isarHelper;

  int _total = 0;
  int _currentItemNumber = 0;

  int get total => _total;
  void _setCurrentTotal(int newTotal) {
    _total = newTotal;
    notifyListeners();
  }

  int get currentItemNumber => _currentItemNumber;
  void _setCurrentItemNumber(int newItemNumber) {
    _currentItemNumber = newItemNumber;
    notifyListeners();
  }

  bool get isProcessing => _isProcessing;

  List<SearchPageDeclaration> _declarationToBeImported =
      <SearchPageDeclaration>[];
  void _setDeclarationsToBeImported(
    List<SearchPageDeclaration> searchPageDeclarations,
  ) {
    _declarationToBeImported = searchPageDeclarations;
    notifyListeners();
  }

  List<SearchPageDeclaration> get declarationsToBeImported =>
      _declarationToBeImported;

  List<DeclarationImportStatus> _importedDeclarations =
      <DeclarationImportStatus>[];
  void setImportedDeclarations(
    List<DeclarationImportStatus> searchPageDeclarations,
  ) {
    _importedDeclarations = searchPageDeclarations;
    notifyListeners();
  }

  List<DeclarationImportStatus> get importedDeclarations =>
      _importedDeclarations;

  Future<void> startImportingDeclarations({
    required DateTime arrivalDate,
    required DateTime departureDate,
    required String propertyId,
    required DeclarationsPageHeaders headers,
    //? Don't import searchPageData -
    //? you might get a bit faster for longer durations
    //? But if anything ever goes wrong it will be harder to debug.
  }) async {
    if (_isProcessing) {
      _requestNewImportSession = true; //?Used to break the current import.
      while (true) {
        await Future<void>.delayed(const Duration(seconds: 1));
        if (!_isProcessing) {
          setIsImporting(true);
          _requestNewImportSession = false;
          break;
        }
      }
    } else {
      setIsImporting(true); //?Notify listeners as well
    }
    await setSearchPageDateRange(
      //?Don't import the initial search page data -
      arrivalDate: arrivalDate,
      departureDate: departureDate,
      propertyId: propertyId,
      headers: headers,
    );

    SearchPageData currentSearchPageData = await getDeclarationSearchPage(
      headers: headers,
      propertyId: propertyId,
    );
    _setDeclarationsToBeImported(currentSearchPageData.declarations);
    _setCurrentTotal(currentSearchPageData.total);

    final int rounds = (currentSearchPageData.total ~/ 50) + 1;

    DateTime nextArrivalDate =
        currentSearchPageData.declarations.last.arrivalDate;

    for (int j = 0; j < rounds; j++) {
      if (j > 0) {
        if (_requestNewImportSession) break; //!!

        await setSearchPageDateRange(
          arrivalDate: nextArrivalDate,
          departureDate: departureDate,
          propertyId: propertyId,
          headers: headers,
        );
        currentSearchPageData = await getDeclarationSearchPage(
          headers: headers,
          propertyId: propertyId,
        );
        nextArrivalDate = currentSearchPageData.declarations.last.arrivalDate;
        _setDeclarationsToBeImported(currentSearchPageData.declarations);
      }

      await importCurrentSearchPageDeclarations(
        currentSearchPageData,
        propertyId,
        headers,
      );
    }

    setIsImporting(false);
    _setCurrentTotal(0);
    _setCurrentItemNumber(0);
  }

  Future<void> importCurrentSearchPageDeclarations(
    SearchPageData currentSearchPageData,
    String propertyId,
    DeclarationsPageHeaders headers,
  ) async {
    for (int i = 0; i < currentSearchPageData.declarations.length; i++) {
      if (_requestNewImportSession) break; //!!
      bool imported = false;

      _setCurrentItemNumber(currentItemNumber + 1);

      final SearchPageDeclaration searchPageDeclaration =
          currentSearchPageData.declarations[i];

      try {
        int? declarationLocalId = await _isarHelper.declarationActions
            .searchPageDeclarationAlreadyExists(
          declaration: searchPageDeclaration,
          propertyId: propertyId,
        );

        if (declarationLocalId == null) {
          imported = true;
          final SearchPageData? searchPageData =
              await Future.any(<Future<SearchPageData?>>[
            getDeclarationSearchPage(
              //?Used to get a new viewState for each propertyId
              headers: headers,
              propertyId: propertyId,
            ),
            Future<void>.delayed(const Duration(minutes: 2)).then((_) => null),
          ]);

          if (searchPageData == null) throw TimedOutException();
          final DetailedDeclaration detailedDeclaration =
              await getDeclarationFromSearchPageData(
            declarationIndex: i,
            headers: headers,
            status: searchPageDeclaration.status,
            declarationType: searchPageDeclaration.type,
            parsedViewState: searchPageData.viewStateParsed,
            propertyId: propertyId,
          );

          if (detailedDeclaration.finalizedDeclarationDetails != null) {
            (await _isarHelper.declarationActions
                .insertMultipleFinalizedDeclarationsToDb(
              <FinalizedDeclarationDetails>[
                detailedDeclaration.finalizedDeclarationDetails!,
              ],
            ));
          }

          declarationLocalId =
              (await _isarHelper.declarationActions.insertMultipleEntriesToDb(
            <Declaration>[detailedDeclaration.baseDeclaration],
          ))
                  .first;
        }
        final Declaration? declaration =
            await _isarHelper.declarationActions.getDeclarationEntryByIsarId(
          declarationLocalId,
        );
        _setDeclarationsToBeImported(
          List<SearchPageDeclaration>.from(declarationsToBeImported)
            ..removeAt(0),
        );
        if (declaration != null) {
          setImportedDeclarations(
            List<DeclarationImportStatus>.from(importedDeclarations)
              ..add(
                DeclarationImportStatus(
                  declaration: declaration,
                  imported: imported,
                ),
              ),
          );
        }
      } catch (error) {
        _setDeclarationsToBeImported(
          List<SearchPageDeclaration>.from(declarationsToBeImported)
            ..removeAt(0),
        );
        setImportedDeclarations(
          List<DeclarationImportStatus>.from(importedDeclarations)
            ..add(
              DeclarationImportStatus(
                declaration: Declaration(
                  propertyId: propertyId,
                  declarationDbId: 1,
                  bookingPlatform: BookingPlatform.other,
                  arrivalDate: DateTime(2018),
                  departureDate: DateTime(2018),
                  payout: 0,
                  declarationStatus: DeclarationStatus.undeclared,
                  serialNumber: 0,
                ),
                imported: false,
              ),
            ),
        );
        // ignore: avoid_print
        print(error);
      }
    }
  }
}
