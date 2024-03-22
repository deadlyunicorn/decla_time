import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:http/http.dart" as http;

Future<void> deleteTemporaryDeclarationByDeclarationDbId({
  required DeclarationsPageHeaders headers,
  required String propertyId,
  required int declarationDbId,
}) async {
  final String viewState = await http
      .get(
        Uri.parse(
          "https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml?propertyId=$propertyId&declarationDbId=$declarationDbId",
        ),
        headers: headers.getHeadersForGET(),
      )
      .then(
        (http.Response res) =>
            getBetweenStrings(res.body, 'ViewState" value="', '"'),
      );

  await http.post(
    Uri.parse(
      "https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml",
    ),
    body:
    // ignore: lines_longer_than_80_chars
        "javax.faces.partial.ajax=true&javax.faces.source=appForm%3AdeleteButton&javax.faces.partial.execute=%40all&javax.faces.partial.render=appForm&appForm%3AdeleteButton=appForm%3AdeleteButton&appForm=appForm&javax.faces.ViewState=$viewState",
    headers: headers.getHeadersForPOST(),
  );
}
