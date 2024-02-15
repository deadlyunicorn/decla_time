import 'package:http/http.dart';
import 'package:http/http.dart' as http;

Request nonRedirectingRequest(
    {required Uri url, required String? cookies, required String method}) {
  final request = http.Request(method, url);

  request.headers.addAll({"Cookie": cookies ?? ""});
  request.followRedirects = false;
  return request;
}
