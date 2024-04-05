import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:decla_time/declarations/utility/declaration_body.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/network_requests/post_new_declaration_request.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/src/response.dart";
import "values.dart";

void main() async {
  test("Test that creates a new declaration", () async {
    final DeclarationsPageHeaders testingHeaders = await loginUser(
      credentials: UserCredentials(username: username, password: password),
    );

    final String samplePropertyId = propertyId;

    final DeclarationBody testDeclarationBody = DeclarationBody(
      cancellationAmount: null,
      cancellationDate: null,
      arrivalDate: DateTime.now(),
      departureDate: DateTime.now().add(const Duration(days: 3)),
      payout: 0.01,
      platform: "Airbnb",
    );

    final Response res1 = await postNewDeclarationRequest(
      headersObject: testingHeaders,
      newDeclarationBody: testDeclarationBody,
      propertyId: samplePropertyId,
    );

    final String errorMessage =
        getBetweenStrings(res1.body, 'ui-messages-error-detail">', "</span>");
    expect(errorMessage, "");
    final String infoMessage =
        getBetweenStrings(res1.body, 'ui-messages-info-detail">', "</span>");
    expect(infoMessage, "Επιτυχής Αποθήκευση");
  });
}
