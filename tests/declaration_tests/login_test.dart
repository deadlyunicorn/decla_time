// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'fifth_page_headers.dart';
import 'first_page_headers.dart';
import 'fourth_page_headers.dart';
import 'get_values_between_strings.dart';
import 'second_page_headers.dart';
import 'third_page_headers.dart';
import 'user_credentials.dart';
import 'values.dart';

void main() async {
  test(
    "Test that logins to the service and retrieves cookies",
    () async {
      final requiredSessionCookies = await loginUser(
          credentials: UserCredentials(username: username, password: password));
      final declarationsPage = await http
          .get(
            Uri.https("www1.aade.gr", "taxisnet/short_term_letting"),
            headers: requiredSessionCookies.getHeadersForGET(),
          )
          .then(
            (res) => res.body,
          );

      expect(requiredSessionCookies.oamAuthnCookie?.endsWith("%3D"), true);
      expect(
        declarationsPage
            .contains("<title>Μητρώο Ακινήτων Βραχυχρόνιας Διαμονής</title>"),
        true,
      );
    },
  );
}

Future<DeclarationsPageHeaders> loginUser(
    {required UserCredentials credentials}) async {
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

  // //*3rd request (login submit button) - POST
  final res3 = await loginRequest(
    thirdResponseHeaders: thirdResponseHeaders,
    loginBody: credentials.generateLoginBody(thirdResponseHeaders.requestId),
  ).send();

  final fourthPageHeaders = FourthPageHeaders.getFromResponse(
    firstPageGsisCookie: firstResponseHeaders.gsisCookie,
    streamedResponse: res3,
    previousPageHeaders: thirdResponseHeaders,
  );

  // //*4th request obrar.cgi encreply - GET -- > oamAuthnCookie
  final res4 = await nonRedirectingRequest(
    url: fourthPageHeaders.nextUrl,
    cookies: fourthPageHeaders.cookies,
    method: "GET",
  ).send();

  final fifthPageHeaders = FifthPageHeaders.getFromResponse(
    streamedResponse: res4,
    previousPageHeaders: fourthPageHeaders,
  );

  // //*5th request - short-term-letting - GET
  final res5 = await http.get(
    fifthPageHeaders.nextUrl,
    headers: {"cookie": fifthPageHeaders.cookies},
  );

  return getRequiredSessionCookies(
    res5,
    fifthPageHeaders,
  );
}

DeclarationsPageHeaders getRequiredSessionCookies(
  http.Response res5,
  FifthPageHeaders fifthPageHeaders,
) {
  final jSessionId =
      getBetweenStrings(res5.headers.toString(), ",JSESSIONID=", ";");
  final wl_authCookie_jSessionId = getBetweenStrings(
      res5.headers.toString(), "_WL_AUTHCOOKIE_JSESSIONID=", ";");
  final gsisCookie = fifthPageHeaders.gsisCookie;

  //*refreshes*
  final oamAuthnCookie = fifthPageHeaders.oamAuthnCookie;

  final requiredHeaders = DeclarationsPageHeaders(
    gsisCookie: gsisCookie,
    wl_authCookie_jSessionId: wl_authCookie_jSessionId,
    jSessionId: jSessionId,
  );
  return requiredHeaders..newSession(oamAuthnCookie: oamAuthnCookie);
}

http.Request loginRequest({
  required ThirdPageHeaders thirdResponseHeaders,
  required String loginBody,
}) {
  final req3 = nonRedirectingRequest(
    method: "POST",
    url: thirdResponseHeaders.nextUrl,
    cookies: thirdResponseHeaders.cookies,
  );
  req3.headers.addAll({
    "content-type": "application/x-www-form-urlencoded",
  });
  req3.body = loginBody;
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
