import "package:decla_time/declarations/utility/network_requests/get_declaration_search_page.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/search_page_data.dart";

Future<SearchPageData> getSearchPageDetailsFromDateRangeFuture({
  required DateTime arrivalDate,
  required DateTime departureDate,
  required String propertyId,
  required DeclarationsPageHeaders headers,
}) async {
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

  return currentSearchPageData;

  // final int rounds = (currentSearchPageData.total ~/ 50) + 1;

  // if (displayTotalFound != null) {
  //   displayTotalFound(currentSearchPageData.total);
  // }
  // if (currentSearchPageData.declarations.isEmpty) return;

  // DateTime nextArrivalDate =
  //     currentSearchPageData.declarations.last.arrivalDate;

  // for (int j = 0; j < rounds; j++) {
  //   if (j > 0) {
  //     await setSearchPageDateRange(
  //       arrivalDate: nextArrivalDate,
  //       departureDate: departureDate,
  //       propertyId: propertyId,
  //       headers: headers,
  //     );
  //     currentSearchPageData = await getDeclarationSearchPage(
  //       headers: headers,
  //       propertyId: propertyId,
  //     );
  //     nextArrivalDate = currentSearchPageData.declarations.last.arrivalDate;
  //   }

  //   for (int i = 0; i < currentSearchPageData.declarations.length; i++) {
  //     SearchPageDeclaration currentDeclaration =
  //         currentSearchPageData.declarations[i];
  //     // print("ROUND $j, DECLARATION No. $i");

  //     final bool existsInDb =
  //         await checkIfDeclarationExistsInDb(currentDeclaration);
  //     if (displayCurrentStatus != null) {
  //       displayCurrentStatus(
  //         index: i,
  //         total: currentSearchPageData.total,
  //         existsInDb: existsInDb,
  //       );
  //     }

  //     if (existsInDb) continue;

  //     await Future<void>.delayed(const Duration(milliseconds: 500));
  //     final SearchPageData searchPageData = await getDeclarationSearchPage(
  //       //?Used to get a new viewState for each propertyId
  //       headers: headers,
  //       propertyId: propertyId,
  //     );

  //     final Declaration declaration = await getDeclarationFromSearchPageData(
  //       declarationIndex: i,
  //       headers: headers,
  //       parsedViewState: searchPageData.viewStateParsed,
  //       propertyId: propertyId,
  //     );

  //     await storeDeclarationInDb(declaration);
  //   }
  // }
}
