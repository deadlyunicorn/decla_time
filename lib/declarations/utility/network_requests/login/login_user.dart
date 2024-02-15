import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/generate_session_cookies.dart';
import 'package:decla_time/declarations/utility/network_requests/login/headers/fifth_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/headers/first_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/headers/fourth_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/headers/second_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/headers/third_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/submit_login_credentials_request.dart';
import 'package:decla_time/declarations/utility/network_requests/non_redirecting_request.dart';
import 'package:decla_time/declarations/utility/user_credentials.dart';
import 'package:http/http.dart' as http;


Future<DeclarationsPageHeaders> loginUser({
  required UserCredentials credentials,
}) async {
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
  final res3 = await submitLoginCredentialsRequest(
    thirdResponseHeaders: thirdResponseHeaders,
    credentials: credentials,
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

  return generateSessionCookies(
    res5,
    fifthPageHeaders,
  );
}
