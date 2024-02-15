// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'package:decla_time/declarations/login/declaration_body.dart';
import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'get_values_between_strings.dart';
import 'values.dart';

void main() async {
  test("Test that creates a new declaration", () async {
    final testingHeaders = getTestHeaders();
    final samplePropertyId = propertyId;

    final newDeclarationPage = await http.get(
      //?We get a new ViewState from here
      Uri.parse(
        "https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml?propertyId=$samplePropertyId",
      ),
      headers: testingHeaders.getHeadersForGET(),
    );

    final viewState =
        getBetweenStrings(newDeclarationPage.body, 'ViewState" value="', '"');

    final testDeclarationBody = DeclarationBody(
      arrivalDate: DateTime.now(),
      departureDate: DateTime.now().add(const Duration(days: 3)),
      payout: 0.01,
      platform: "Airbnb",
      viewState: viewState,
    );

    await setRenterName(testingHeaders,
        testDeclarationBody); //? This renter name is set automatically when we 'change' the afm field. In most cases you'll set a 000 000 000 afm.

    final res1 = await postNewDeclarationRequest(
      headersObject: testingHeaders,
      newDeclarationBodyString: testDeclarationBody.bodyString,
    );

    final errorMessage =
        getBetweenStrings(res1.body, 'ui-messages-error-detail">', "</span>");
    expect(errorMessage, "");
    final infoMessage =
        getBetweenStrings(res1.body, 'ui-messages-info-detail">', "</span>");
    expect(infoMessage, "Επιτυχής Αποθήκευση");
  });
}

Future<void> setRenterName(DeclarationsPageHeaders testingHeaders,
    DeclarationBody testDeclarationBody) async {
  await http.post(
    Uri.parse(
      "https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml",
    ),
    headers: testingHeaders.getHeadersForPOST(),
    body:
        "javax.faces.partial.ajax=true&javax.faces.source=appForm%3ArenterAfm&javax.faces.partial.execute=appForm%3ArenterAfm&javax.faces.partial.render=appForm%3Amessages+appForm%3ArenterAfm+appForm%3ArenterName&javax.faces.behavior.event=change&javax.faces.partial.event=change&appForm=appForm&appForm%3ArentalFrom_input=&appForm%3ArentalTo_input=&appForm%3AsumAmount_input=&appForm%3AsumAmount_hinput=&appForm%3ApaymentType_input=&appForm%3ApaymentType_focus=&appForm%3Aplatform_input=&appForm%3Aplatform_focus=&appForm%3ArenterAfm=000000000&appForm%3AcancelAmount_input=&appForm%3AcancelAmount_hinput=&appForm%3AcancelDate_input=&appForm%3Aj_idt93=&javax.faces.ViewState=${testDeclarationBody.viewStateParsed}",
  );
}

Future<Response> postNewDeclarationRequest({
  required DeclarationsPageHeaders headersObject,
  required String newDeclarationBodyString,
}) async {
  return http.post(
    Uri.https(
      "www1.aade.gr",
      "taxisnet/short_term_letting/views/declaration.xhtml",
    ),
    headers: headersObject.getHeadersForPOST(),
    body: newDeclarationBodyString,
  );
}
