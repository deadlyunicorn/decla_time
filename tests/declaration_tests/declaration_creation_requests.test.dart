// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'dart:io';

import 'package:decla_time/declarations/login/declaration_body.dart';
import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'test_headers.dart';

void main() async {
  //! Step 1: Get to the Declaration Form. Get a valid view_state from it.

  test("Test that creates a new declaration", () async {
    final testingHeaders = DeclarationsPageHeaders(///? Either use the login function or provide manual values.
      gsisCookie: "",
      jSessionId: "",
      wl_authCookie_jSessionId: "",
    );

    // final res1 = await createNewDeclarationRequest(
    //   headersObject: testingHeaders,
    //   newDeclarationBodyString: DeclarationBody.declarationCreationBody,
    // );
    final res1 = await createNewDeclarationRequest(
      headersObject: testingHeaders,
      newDeclarationBodyString: DeclarationBody(
              arrivalDate: DateTime.now(),
              departureDate: DateTime.now().add(const Duration(days: 3)),
              payout: 0.08,
              platform: "Airbnb",
              viewState: (() {
                return null;
              })())
          .bodyString,
    );

    print(res1.body); //!! returns a ViewState.
    print(res1.statusCode);

    expect(res1.statusCode, 200); //TODO make an actual test.
  });
}

Future<Response> createNewDeclarationRequest({
  required DeclarationsPageHeaders headersObject,
  required String newDeclarationBodyString,
}) async {
  return http.post(
    Uri.https(
        "www1.aade.gr", "taxisnet/short_term_letting/views/declaration.xhtml"),
    headers: headersObject.getHeadersForPOST(),
    body: newDeclarationBodyString,
  );
}
