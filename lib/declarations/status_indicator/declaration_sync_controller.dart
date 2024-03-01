import "dart:async";

import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/status_indicator/declaration_status.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_details_from_search_page_data.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_search_page.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/search_page_data.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:flutter/material.dart";

class DeclarationSyncController extends ChangeNotifier {
  bool _requestNewImportSession = false;
  bool _isImporting = false;
  void setIsImporting(bool newState) {
    _isImporting = newState;
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

  bool get isImporting => _isImporting;

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
  }) async {
    if (_isImporting) {
      _requestNewImportSession = true; //?Used to break the current import.
      while (true) {
        print("requesting new session");
        await Future<void>.delayed(const Duration(seconds: 1));
        if (!_isImporting) {
          setIsImporting(true);
          _requestNewImportSession = false;
          break;
        }
      }
    } else {
      setIsImporting(true); //?Notify listeners as well
    }
    await setSearchPageDateRange(
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

      //TODO look if it's a final declaration.
      //TODO think of storing it in a variable 'isFinal'.
      //TODO or just connect declartion with finalizedDeclartionDetails them with propertyDbId.

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

      final SearchPageDeclaration currentDeclaration =
          currentSearchPageData.declarations[i];

      try {
        int? declarationLocalId = await _isarHelper.declarationActions
            .searchPageDeclarationAlreadyExists(
          declaration: currentDeclaration,
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
          final Declaration declaration =
              await getDeclarationFromSearchPageData(
            declarationIndex: i,
            headers: headers,
            parsedViewState: searchPageData.viewStateParsed,
            propertyId: propertyId,
          );

          declarationLocalId = (await _isarHelper.declarationActions
                  .insertMultipleEntriesToDb(<Declaration>[declaration]))
              .first;
        }
        _setDeclarationsToBeImported(
          List<SearchPageDeclaration>.from(declarationsToBeImported)
            ..removeAt(0),
        );
        setImportedDeclarations(
          List<DeclarationImportStatus>.from(importedDeclarations)
            ..add(
              DeclarationImportStatus(
                imported: imported,
                localDeclarationId: declarationLocalId,
              ),
            ),
        );
      } catch (error) {
        print(error);
      }
    }
  }
}
