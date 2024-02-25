import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:decla_time/declarations/functions/check_if_logged_in.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:http/http.dart" as http;

///? In our query parameters we can either specify a specific declarationDbId,
///?  or request a new declaration.
Future<String> getDeclarationPageViewState({
  required Map<String, String> declarationQueryParameters,
  required DeclarationsPageHeaders testingHeaders,
}) async {
  return await http
      .get(
    Uri.https(
      "www1.aade.gr",
      "taxisnet/short_term_letting/views/declaration.xhtml",
      declarationQueryParameters,
    ),
    headers: testingHeaders.getHeadersForGET(),
  )
      .then(
    (http.Response res) {
      final String body = res.body;
      checkIfLoggedIn(body);
      return getBetweenStrings(
        body,
        'id="javax.faces.ViewState" value="',
        '"',
      );
    },
  );
}
