// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'first_page_headers.dart';
import 'second_page_headers.dart';
import 'third_page_headers.dart';
import 'user_credentials.dart';
import 'values.dart';

void main() async {
  test(
    "Test that logins to the service and retrieves cookies",
    () async {
      //*0th request (login page) GET //No Cookies
      final res0 = await nonRedirectingRequest(
        url: Uri.https("www1.aade.gr", "taxisnet/short_term_letting"),
        cookies: "",
      );

      final firstResponseHeaders = FirstPageHeaders.getFromResponse(res0);

      //*1st request (obrareq) GET //First set of Cookies
      final res1 = await nonRedirectingRequest(
        url: firstResponseHeaders.nextUrl,
        cookies: firstResponseHeaders.cookies,
      );

      final secondResponseHeaders = SecondPageHeaders.getFromResponse(
        previousPageHeaders: firstResponseHeaders,
        streamedResponse: res1,
      );

      //*2nd request (login.jsp?bmctx) GET //Second set of Cookies
      final res2 = await nonRedirectingRequest(
        url: secondResponseHeaders.nextUrl,
        cookies: secondResponseHeaders.cookies,
      );

      final thirdResponseHeaders = ThirdPageHeaders.getFromResponse(
        streamedResponse: res2,
        previousPageHeaders: secondResponseHeaders,
      ); //* We don't get a nextUrl from this one

      {
        // //*3rd request (submit button) - POST
        final req3 = await loginPostRequest( headers: thirdResponseHeaders);
        print( req3.headers ); 
      }

/*
      print("FIRST");
      firstResponseHeaders.printProperties();
      print(" ");
      print("SECOND");

      secondResponseHeaders.printProperties();
      print(" ");
      print("THIRD");
      loginHeaders.printProperties();

      */
    },
  );
}

Future<StreamedResponse> loginPostRequest( {
  required ThirdPageHeaders headers
  }) async {
  final loginRequest = http.Request(
    "POST",
    Uri.parse(
      "https://login.gsis.gr/oam/server/auth_cred_submit",
    ),
  );
  loginRequest.headers.addAll({
    "cookie": headers.cookies,
    // "OAM_REQ_0=${headers.oam_req_0}; OAM_REQ_COUNT=VERSION_4~1; ECID-Context=${headers.ecidContext}; gsis_cookie=${headers.gsisCookie}; OAM_JSESSIONID=${headers.oam_JSESSIONID}",
    "content-type": "application/x-www-form-urlencoded", //!SOS just like OAM_REQ_COUNT=VERSION_4~1
  });
  loginRequest.body = LoginBodyFields(
    username: username,
    password: password,
    requestId: headers.requestId,
  ).loginBody;
  loginRequest.followRedirects = false;
  return await loginRequest.send();
}

Future<StreamedResponse> nonRedirectingRequest({
  required Uri url,
  required String? cookies,
}) async {
  final request = http.Request("GET", url);

  request.headers.addAll({"Cookie": cookies ?? ""});
  request.followRedirects = false;
  return await request.send();
}

String toStringMax60(Object anyObject) {
  final stringObject = anyObject.toString();
  return stringObject.substring(0, min(stringObject.length, 60));
}
