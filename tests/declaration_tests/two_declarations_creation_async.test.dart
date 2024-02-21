//! THIS IS FOR TESTING AND DEMONSTRATIVE PURPOSES ONLY
//! NOT MEANT TO BE USED IN PRODUCTION.

import 'package:decla_time/core/enums/declaration_status.dart';
import 'package:decla_time/declarations/utility/declaration_body.dart';
import 'package:decla_time/declarations/utility/network_requests/get_declaration_search_page.dart';
import 'package:decla_time/declarations/utility/network_requests/get_user_properties.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/login_user.dart';
import 'package:decla_time/declarations/utility/network_requests/post_new_declaration_request.dart';
import 'package:decla_time/declarations/utility/user_credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'values.dart';

void main() async {
  //! dont run this test
  // test("Test that deletes a temporary declaration", () async {
    final DeclarationsPageHeaders testingHeaders = await loginUser(
        credentials: UserCredentials(username: username, password: password));

    //* STEP 1:GETTING THE propertyId
    final propertyId = (await getUserProperties(testingHeaders))[0].propertyId; //? Also checks if Logged In

    //* STEP 2:GETTING the available declarations
    final declarationSearchPageDataBefore = await getDeclarationSearchPage(
      headers: testingHeaders,
      propertyId: propertyId,
    );

    final temporaryDeclarationsBefore = declarationSearchPageDataBefore
        .declarations
        .where(
            (declaration) => declaration.status == DeclarationStatus.temporary)
        .toList();

    final future1 = sendCustomDeclarationRequest__TESTING(0.32, testingHeaders);
    final future2 = sendCustomDeclarationRequest__TESTING(0.64, testingHeaders);

    await Future.wait([future1, future2]);

    final declarationSearchPageDataAfter = await getDeclarationSearchPage(
      headers: testingHeaders,
      propertyId: propertyId,
    );
    final temporaryDeclarationsAfter = declarationSearchPageDataAfter
        .declarations
        .where(
            (declaration) => declaration.status == DeclarationStatus.temporary)
        .toList();

    expect(
      temporaryDeclarationsAfter.length,
      temporaryDeclarationsBefore.length + 2,
    );
  // });
}

// ignore: non_constant_identifier_names
Future<Response> sendCustomDeclarationRequest__TESTING(
        double payout, DeclarationsPageHeaders headersObject) =>
    postNewDeclarationRequest(
      headersObject: headersObject,
      newDeclarationBody: DeclarationBody(
        arrivalDate: DateTime.now(),
        departureDate: DateTime.now().add(const Duration(days: 3)),
        payout: payout,
        platform: "airbnb",
      ),
      propertyId: propertyId,
    );
