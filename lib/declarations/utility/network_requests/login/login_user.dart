import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/declarations/functions/check_if_logged_in.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/generate_session_cookies.dart";
import "package:decla_time/declarations/utility/network_requests/login/headers/fifth_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/headers/first_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/headers/fourth_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/headers/second_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/headers/third_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/submit_login_credentials_request.dart";
import "package:decla_time/declarations/utility/network_requests/non_redirecting_request.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:http/http.dart" as http;

Future<DeclarationsPageHeaders> loginUser({
  required UserCredentials credentials,
}) async {
  //*0th request (login page) GET //No Cookies
  final http.StreamedResponse res0 = await nonRedirectingRequest(
    method: "GET",
    url: Uri.https("www1.aade.gr", "taxisnet/short_term_letting"),
    cookies: "",
  ).send();

  final FirstPageHeaders firstResponseHeaders =
      FirstPageHeaders.getFromResponse(res0);

  //*1st request (obrareq) GET //First set of Cookies
  final http.StreamedResponse res1 = await nonRedirectingRequest(
    method: "GET",
    url: firstResponseHeaders.nextUrl,
    cookies: firstResponseHeaders.cookies,
  ).send();

  final SecondPageHeaders secondResponseHeaders =
      SecondPageHeaders.getFromResponse(
    previousPageHeaders: firstResponseHeaders,
    streamedResponse: res1,
  );

  //*2nd request (login.jsp?bmctx) GET //Second set of Cookies
  final http.StreamedResponse res2 = await nonRedirectingRequest(
    method: "GET",
    url: secondResponseHeaders.nextUrl,
    cookies: secondResponseHeaders.cookies,
  ).send();

  final ThirdPageHeaders thirdResponseHeaders =
      ThirdPageHeaders.getFromResponse(
    streamedResponse: res2,
    previousPageHeaders: secondResponseHeaders,
  ); //* We don't get a nextUrl from this one

  // //*3rd request (login submit button) - POST
  final http.StreamedResponse res3 = await submitLoginCredentialsRequest(
    thirdResponseHeaders: thirdResponseHeaders,
    credentials: credentials,
  ).send();

  final FourthPageHeaders fourthPageHeaders = FourthPageHeaders.getFromResponse(
    firstPageGsisCookie: firstResponseHeaders.gsisCookie,
    streamedResponse: res3,
    previousPageHeaders: thirdResponseHeaders,
  );

  // //*4th request obrar.cgi encreply - GET -- > oamAuthnCookie
  final http.StreamedResponse res4 = await nonRedirectingRequest(
    url: fourthPageHeaders.nextUrl,
    cookies: fourthPageHeaders.cookies,
    method: "GET",
  ).send();

  final FifthPageHeaders fifthPageHeaders = FifthPageHeaders.getFromResponse(
    streamedResponse: res4,
    previousPageHeaders: fourthPageHeaders,
  );

  // //*5th request - short-term-letting - GET
  final http.Response res5 = await http.get(
    fifthPageHeaders.nextUrl,
    headers: <String, String>{"cookie": fifthPageHeaders.cookies},
  );

  try {
    checkIfLoggedIn(res5.body);
  } on NotLoggedInException {
    throw LoginFailedExcepetion();
  }

  return generateSessionCookies(
    res5,
    fifthPageHeaders,
  );
}
