import 'package:decla_time/core/extensions/get_values_between_strings.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:http/http.dart' as http;

///? This is actually a POST request -
Future<String> getDeclarationDbIdFromDeclarationsListPage({
  required String parsedViewState,
  required int declarationIndex,
  required DeclarationsPageHeaders headers,
}) async {
  return await http
      .post(
        Uri.https(
          "www1.aade.gr",
          "taxisnet/short_term_letting/views/declarationSearch.xhtml",
        ), //?Once the viewState has been used in a POST request - it can't be used again..
        body:
            "javax.faces.ViewState=$parsedViewState&javax.faces.source=appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails&javax.faces.partial.ajax=true&javax.faces.partial.execute=%40all&appForm=appForm&appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails=appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails",
        headers: headers.getHeadersForPOST(),
      )
      .then(
        (res) => getBetweenStrings(res.body, "declarationDbId=", '"'),
      );
}
