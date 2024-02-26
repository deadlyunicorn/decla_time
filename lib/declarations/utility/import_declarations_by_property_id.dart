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

}
