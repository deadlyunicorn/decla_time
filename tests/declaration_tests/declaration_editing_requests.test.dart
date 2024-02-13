// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'dart:io';

import 'package:decla_time/declarations/login/declaration_body.dart';
import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'test_headers.dart';

void main() async {
  test("Test that edits a declaration", () async{
    final declarationBody = DeclarationBody(
      arrivalDate: DateTime.now(),
      departureDate: DateTime.now().add(const Duration(days: 2)),
      payout: 0.01,
      platform: "booking",
    );

    final testingHeaders = await getTestHeadersFromFileFuture( File("headers.txt")); //? Is in .gitignore
    final res = await editDeclarationRequest( 
      headersObject: testingHeaders,
      bodyString: declarationBody.bodyString,//!Outdated - need to specify a viewState - this specifies the declaration..
    );

    expect( res.statusCode, 200); //TODO make an actual test.
  });

  
}

Future<Response> editDeclarationRequest({
  required DeclarationsPageHeaders headersObject,
  required String bodyString,
}) async {
  declarationAttemptResponse() async => await http.post(
        Uri.https("www1.aade.gr",
            "taxisnet/short_term_letting/views/declaration.xhtml"),
        headers: headersObject.getHeaders(),
        body: bodyString, 
      );

  final res = (await declarationAttemptResponse());
  if (res.statusCode == 302) {
    print("our cookie timed out..");

    // headersObject.customSession( //?new session.. @Unimplemented..
    //   oamAuthnCookie:",
    // );
    // await declarationAttemptResponse(); //or do something recursive with delat() like await sendPaymentRequest();
  } else if (res.statusCode == 401) {
    print("jSessionId cookie expired");
  } else {
    print(res.statusCode);
  }

  return res;
}

