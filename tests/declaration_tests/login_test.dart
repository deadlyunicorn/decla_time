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
        method: "GET",
        url: Uri.https("www1.aade.gr", "taxisnet/short_term_letting"),
        cookies: "",
      ).send();

      final firstResponseHeaders = FirstPageHeaders.getFromResponse(res0);

      //*1st request (obrareq) GET //First set of Cookies
      final res1 = await nonRedirectingRequest(
        method: "GET",
        url: firstResponseHeaders.nextUrl,
        cookies: firstResponseHeaders.cookies,
      ).send();

      final secondResponseHeaders = SecondPageHeaders.getFromResponse(
        previousPageHeaders: firstResponseHeaders,
        streamedResponse: res1,
      );

      //*2nd request (login.jsp?bmctx) GET //Second set of Cookies
      final res2 = await nonRedirectingRequest(
        method: "GET",
        url: secondResponseHeaders.nextUrl,
        cookies: secondResponseHeaders.cookies,
      ).send();

      final thirdResponseHeaders = ThirdPageHeaders.getFromResponse(
        streamedResponse: res2,
        previousPageHeaders: secondResponseHeaders,
      ); //* We don't get a nextUrl from this one

      {
        // //*3rd request (login submit button) - POST
        final res3 = await loginRequest(thirdResponseHeaders).send();
        print(res3.headers);
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

http.Request loginRequest(ThirdPageHeaders thirdResponseHeaders) {
  final req3 = nonRedirectingRequest(
    method: "POST",
    url: thirdResponseHeaders.nextUrl,
    cookies: thirdResponseHeaders.cookies,
  );
  req3.headers.addAll({
    "content-type": "application/x-www-form-urlencoded",
  });
  req3.body = LoginBodyFields(
    username: username,
    password: password,
    requestId: thirdResponseHeaders.requestId,
  ).loginBody;
  return req3;
}

Request nonRedirectingRequest(
    {required Uri url, required String? cookies, required String method}) {
  final request = http.Request(method, url);

  request.headers.addAll({"Cookie": cookies ?? ""});
  request.followRedirects = false;
  return request;
}

String toStringMax60(Object anyObject) {
  final stringObject = anyObject.toString();
  return stringObject.substring(0, min(stringObject.length, 60));
}
