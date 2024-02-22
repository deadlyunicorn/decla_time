import 'package:decla_time/core/extensions/get_values_between_strings.dart';
import 'package:decla_time/declarations/utility/declaration_body.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/login_user.dart';
import 'package:decla_time/declarations/utility/network_requests/post_new_declaration_request.dart';
import 'package:decla_time/declarations/utility/user_credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'values.dart';

void main() async {
  test("Test that creates a new declaration", () async {
    final DeclarationsPageHeaders testingHeaders = await loginUser(
      credentials: UserCredentials(username: username, password: password),
    );

    final samplePropertyId = propertyId;

    final testDeclarationBody = DeclarationBody(
      arrivalDate: DateTime.now(),
      departureDate: DateTime.now().add(const Duration(days: 3)),
      payout: 0.01,
      platform: "Airbnb",
    );

    final res1 = await postNewDeclarationRequest(
      headersObject: testingHeaders,
      newDeclarationBody: testDeclarationBody,
      propertyId: samplePropertyId,
    );

    //TODO return the declarationDbId.

    final errorMessage =
        getBetweenStrings(res1.body, 'ui-messages-error-detail">', "</span>");
    expect(errorMessage, "");
    final infoMessage =
        getBetweenStrings(res1.body, 'ui-messages-info-detail">', "</span>");
    expect(infoMessage, "Επιτυχής Αποθήκευση");
  });
}
