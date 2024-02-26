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

  List<SearchPageDeclaration> _currentDeclarations = <SearchPageDeclaration>[];
  void setCurrentDeclarations(
    List<SearchPageDeclaration> searchPageDeclarations,
  ) {
    _currentDeclarations = searchPageDeclarations;
    notifyListeners();
  }

  List<SearchPageDeclaration> get currentDeclarations => _currentDeclarations;

  List<DeclarationImportStatus> _totalImportedDeclarationStatus =
      <DeclarationImportStatus>[];
  void setTotalImportedDeclarations(
    List<DeclarationImportStatus> searchPageDeclarations,
  ) {
    _totalImportedDeclarationStatus = searchPageDeclarations;
    notifyListeners();
  }

  List<DeclarationImportStatus> get totalImportedDeclarations =>
      _totalImportedDeclarationStatus;

  Future<void> startImportingDeclarations({
    ///TODO HERE!!
    required BuildContext declarationPageContext,
    required DateTime arrivalDate,
    required DateTime departureDate,
    required String propertyId,
    required UserCredentials credentials,
  }) async {
    if (_isImporting) {
      _requestNewImportSession = true; //?Used to break the current import.
      while (true) {
        print("waiting for current import to break");
        await Future<void>.delayed(const Duration(seconds: 1));
        if (!_isImporting) {
          setIsImporting(true);
          break;
        }
      }
    } else {
      setIsImporting(true); //?Notify listeners as well
    }
    final DeclarationsPageHeaders headers =
        await loginUser(credentials: credentials);

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
      }

      for (int i = 0; i < currentSearchPageData.declarations.length; i++) {
        if (_requestNewImportSession) break; //!!
        _setCurrentItemNumber(currentItemNumber + 1);

        final SearchPageDeclaration currentDeclaration =
            currentSearchPageData.declarations[i];

        // final bool existsInDb =
        // await checkIfDeclarationExistsInDb(currentDeclaration);

        if (true) {
          setTotalImportedDeclarations(
            totalImportedDeclarations
              ..add(
                DeclarationImportStatus(
                  imported: false,
                  payout: double.tryParse(currentDeclaration.payout) ?? 0,
                  arrivalDate: currentDeclaration.arrivalDate,
                  departureDate: currentDeclaration.departureDate,
                ),
              ),
          );
        } else {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          final SearchPageData searchPageData = await getDeclarationSearchPage(
            //?Used to get a new viewState for each propertyId
            headers: headers,
            propertyId: propertyId,
          );
          final Declaration declaration =
              await getDeclarationFromSearchPageData(
            declarationIndex: i,
            headers: headers,
            parsedViewState: searchPageData.viewStateParsed,
            propertyId: propertyId,
          );

          throw UnimplementedError();
          // await storeDeclarationInDb(declaration);
        }
      }
    }
  }
}



//TODO FOR LATER USER
/*
  displayTotalFound: (int totalFound) {
              setHelperText(
                context: context,
                newText: "Total found: $totalFound",
              );
            },
            displayCurrentStatus: ({
              required int index,
              required int total,
              required bool existsInDb,
            }) {
              setHelperText(
                context: context,
                newText: "Is new: ${!existsInDb}\n${index + 1} / $total",
              );
            },
            checkIfDeclarationExistsInDb:
                (SearchPageDeclaration searchPageDeclaration) async {
              const bool exists = false;
              if (!exists) totalNew++;
              return exists;
            },
            storeDeclarationInDb: (Declaration declaration) async {
              print("storing in db");
            },

*/