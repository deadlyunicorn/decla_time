import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/enums/declaration_type.dart";
import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_by_dbid.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:http/http.dart" as http;

///? This is actually a POST request -
Future<DetailedDeclaration> getDeclarationFromSearchPageData({
  required String propertyId,
  required String parsedViewState,
  required int declarationIndex,
  required DeclarationStatus status,
  required DeclarationType declarationType,
  required DeclarationsPageHeaders headers,
}) async {
  final String declarationDbId = await http
      .post(
        Uri.https(
          "www1.aade.gr",
          "taxisnet/short_term_letting/views/declarationSearch.xhtml",
        ), //?Once the viewState has been used in a POST request -
        //? it can't be used again..
        body:
            // ignore: lines_longer_than_80_chars
            "javax.faces.ViewState=$parsedViewState&javax.faces.source=appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails&javax.faces.partial.ajax=true&javax.faces.partial.execute=%40all&appForm=appForm&appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails=appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails",
        headers: headers.getHeadersForPOST(),
      )
      .then(
        (http.Response res) =>
            getBetweenStrings(res.body, "declarationDbId=", '"'),
      );

  return await getDeclarationByDbId(
    headers: headers,
    propertyId: propertyId,
    declarationDbId: declarationDbId,
  );
}
