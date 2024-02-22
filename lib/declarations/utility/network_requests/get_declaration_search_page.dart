import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/search_page_data.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<SearchPageData> getDeclarationSearchPage({
  required DeclarationsPageHeaders headers,
  required String propertyId,
}) async {
  return await http
      .get(
    Uri.https(
      "www1.aade.gr",
      "taxisnet/short_term_letting/views/declarationSearch.xhtml",
      {"propertyId": propertyId},
    ),
    headers: headers.getHeadersForGET(),
  )
      .then((res) {
        // print(res.body);
    return SearchPageData.getFromHtml(res.body);
  });
}


///You should `getDeclarationSearchPage()` after using this procedure
///as it does fetch one inside.

Future<void> setSearchPageDateRange({
  required DateTime arrivalDate,
  required DateTime departureDate,
  required String propertyId,
  required DeclarationsPageHeaders headers,
}) async {
  
  final initialSearchPage =
      await getDeclarationSearchPage(headers: headers, propertyId: propertyId);

  final arrivalDateFormatted = DateFormat("dd%2FMM%2Fy").format(arrivalDate);
  final departureDateFormatted =
      DateFormat("dd%2FMM%2Fy").format(departureDate);

  final body =
      "appForm%3AdateFrom_input=$arrivalDateFormatted&appForm%3AdateTo_input=$departureDateFormatted&javax.faces.ViewState=${initialSearchPage.viewStateParsed}&appForm%3Aj_idt50=appForm%3Aj_idt50&appForm=appForm&javax.faces.partial.ajax=true&javax.faces.source=appForm%3Aj_idt50&javax.faces.partial.execute=%40all&javax.faces.partial.render=appForm%3AbasicDT+appForm%3AtotalDeclarations+appForm%3Asearch_panel&appForm%3Aj_idt51%3Aj_idt68_input=50&appForm%3Aj_idt51%3Aj_idt68_focus=";

  await http.post(
    Uri.parse(
      "https://www1.aade.gr/taxisnet/short_term_letting/views/declarationSearch.xhtml",
    ),
    body: body,
    headers: headers.getHeadersForPOST(),
  );
}
