import "package:decla_time/declarations/utility/network_requests/login/headers/third_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/non_redirecting_request.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:http/http.dart" as http;

http.Request submitLoginCredentialsRequest({
  required ThirdPageHeaders thirdResponseHeaders,
  required UserCredentials credentials,
}) {
  final http.Request req3 = nonRedirectingRequest(
    method: "POST",
    url: thirdResponseHeaders.nextUrl,
    cookies: thirdResponseHeaders.cookies,
  );
  req3.headers.addAll(<String, String>{
    "content-type": "application/x-www-form-urlencoded",
  });
  req3.body = credentials.generateLoginBody(thirdResponseHeaders.requestId);
  return req3;
}
