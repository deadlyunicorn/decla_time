import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/search_page_data.dart';
import 'package:http/http.dart' as http;

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
    return SearchPageData.getFromHtml(res.body);
  });
}
