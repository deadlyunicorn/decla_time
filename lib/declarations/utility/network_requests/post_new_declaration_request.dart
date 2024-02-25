import "package:decla_time/declarations/utility/declaration_body.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_page_view_state.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:http/http.dart";
import "package:http/http.dart" as http;

Future<Response> postNewDeclarationRequest({
  required DeclarationsPageHeaders headersObject,
  required DeclarationBody newDeclarationBody,
  required String propertyId,
}) async {
  final String viewStateParsed = await getDeclarationPageViewState(
    declarationQueryParameters: <String, String>{"propertyId": propertyId},
    testingHeaders: headersObject,
  );

  await setRenterName(
    viewStateParsed: viewStateParsed,
    headersObject: headersObject,
  );
  //? This renter name is set automatically when we 'change' the afm field.
  //? In most cases you'll set a 000 000 000 afm.

  return http.post(
    Uri.https(
      "www1.aade.gr",
      "taxisnet/short_term_letting/views/declaration.xhtml",
    ),
    headers: headersObject.getHeadersForPOST(),
    body: newDeclarationBody.bodyStringPOST(viewStateParsed),
  );
}

Future<void> setRenterName({
  required DeclarationsPageHeaders headersObject,
  required String viewStateParsed,
}) async {
  await http.post(
    Uri.parse(
      "https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml",
    ),
    headers: headersObject.getHeadersForPOST(),
    body:
        // ignore: lines_longer_than_80_chars
        "javax.faces.ViewState=$viewStateParsed&javax.faces.partial.ajax=true&javax.faces.source=appForm%3ArenterAfm&javax.faces.partial.execute=appForm%3ArenterAfm&javax.faces.partial.render=appForm%3Amessages+appForm%3ArenterAfm+appForm%3ArenterName&javax.faces.behavior.event=change&javax.faces.partial.event=change&appForm=appForm&appForm%3ArentalFrom_input=&appForm%3ArentalTo_input=&appForm%3AsumAmount_input=&appForm%3AsumAmount_hinput=&appForm%3ApaymentType_input=&appForm%3ApaymentType_focus=&appForm%3Aplatform_input=&appForm%3Aplatform_focus=&appForm%3ArenterAfm=000000000&appForm%3AcancelAmount_input=&appForm%3AcancelAmount_hinput=&appForm%3AcancelDate_input=&appForm%3Aj_idt93=",
  );
}
