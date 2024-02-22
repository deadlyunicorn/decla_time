import 'package:decla_time/declarations/database/declaration.dart';
import 'package:decla_time/declarations/utility/network_requests/get_declaration_details_from_searchPageData.dart';
import 'package:decla_time/declarations/utility/network_requests/get_declaration_search_page.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/search_page_data.dart';
import 'package:decla_time/declarations/utility/search_page_declaration.dart';

Future<void> importDeclarationsFromDateRangeFuture(
    {required DateTime arrivalDate,
    required DateTime departureDate,
    required String propertyId,
    required DeclarationsPageHeaders headers,
    required Future<bool> Function(SearchPageDeclaration)
        checkIfDeclarationExistsInDb,
    required Future<void> Function(Declaration) storeDeclarationInDb,
    void Function(int)? displayTotalFound,
    void Function(
            {required int index, required int total, required bool existsInDb})?
        displayCurrentStatus}) async {
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

  final rounds = (currentSearchPageData.total ~/ 50) + 1;

  if (displayTotalFound != null) {
    displayTotalFound(currentSearchPageData.total);
  }
  if (currentSearchPageData.declarations.isEmpty) return;

  DateTime nextArrivalDate =
      currentSearchPageData.declarations.last.arrivalDate;

  for (int j = 0; j < rounds; j++) {
    if (j > 0) {
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
      SearchPageDeclaration currentDeclaration =
          currentSearchPageData.declarations[i];
      // print("ROUND $j, DECLARATION No. $i");

      final existsInDb = await checkIfDeclarationExistsInDb(currentDeclaration);
      if (displayCurrentStatus != null) {
        displayCurrentStatus(
          index: i,
          total: currentSearchPageData.total,
          existsInDb: existsInDb,
        );
      }

      if (existsInDb) continue;

      await Future.delayed(const Duration(milliseconds: 500));
      final SearchPageData searchPageData = await getDeclarationSearchPage(
        //?Used to get a new viewState for each propertyId
        headers: headers,
        propertyId: propertyId,
      );

      final declaration = await getDeclarationFromSearchPageData(
        declarationIndex: i,
        headers: headers,
        parsedViewState: searchPageData.viewStateParsed,
        propertyId: propertyId,
      );

      await storeDeclarationInDb(declaration);
    }
  }
}
