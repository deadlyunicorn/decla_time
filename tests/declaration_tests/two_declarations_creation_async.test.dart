//! THIS IS FOR TESTING AND DEMONSTRATIVE PURPOSES ONLY
//! NOT MEANT TO BE USED IN PRODUCTION.

import 'package:decla_time/core/enums/declaration_status.dart';
import 'package:decla_time/declarations/login/declaration_body.dart';
import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'declaration_creation_requests.test.dart';
import 'get_property_ids.test.dart';
import 'test_edit_declaration_longer.test.dart';
import 'values.dart';

void main() async {
  test("Test that deletes a temporary declaration", () async {
    final testingHeaders = getTestHeaders();

    //* STEP 1:GETTING THE propertyId
    final propertyId = (await getUserProperties(testingHeaders))
        .propertyIds[0]; //? Also checks if Logged In

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
  });
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
