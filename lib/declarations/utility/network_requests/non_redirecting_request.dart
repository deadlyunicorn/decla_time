import "package:http/http.dart";
import "package:http/http.dart" as http;

Request nonRedirectingRequest({
  required Uri url,
  required String? cookies,
  required String method,
}) {
  final Request request = http.Request(method, url);

  request.headers.addAll(<String, String>{"Cookie": cookies ?? ""});
  request.followRedirects = false;
  return request;
}
