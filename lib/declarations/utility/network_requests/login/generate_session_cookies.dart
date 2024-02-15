import 'package:decla_time/core/extensions/get_values_between_strings.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/headers/fifth_page_headers.dart';
import 'package:http/http.dart' as http;

DeclarationsPageHeaders generateSessionCookies(
  http.Response res5,
  FifthPageHeaders fifthPageHeaders,
) {
  final jSessionId =
      getBetweenStrings(res5.headers.toString(), ",JSESSIONID=", ";");
  // ignore: non_constant_identifier_names
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
