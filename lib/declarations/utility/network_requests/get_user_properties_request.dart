import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:http/http.dart";
import "package:http/http.dart" as http;

Future<Response> getPropertiesRequest({
  required DeclarationsPageHeaders headersObject,
}) async {
  return http.get(
    Uri.https(
      "www1.aade.gr",
      "taxisnet/short_term_letting/views/propertyRegistry/propertyRegistrySearch.xhtml",
    ),
    headers: headersObject.getHeadersForPOST(),
  );
}
