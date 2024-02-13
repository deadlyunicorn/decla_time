import 'package:http/http.dart';

import 'get_values_between_strings.dart';
import 'login_test.dart';

class FirstPageHeaders {
  final String oamAuthnCookie;
  final String oamRequestContext;
  String gsisCookie;
  final Uri nextUrl;

  void printProperties() {
    // ignore: avoid_print
    print("oamAuthnCookie:${toStringMax60(oamAuthnCookie)}");
    // ignore: avoid_print
    print("oamRequestContext:${toStringMax60(oamRequestContext)}");
    // ignore: avoid_print
    print("gsisCookie:${toStringMax60(gsisCookie)}");
    // ignore: avoid_print
    print("nextUrl:${toStringMax60(nextUrl)}");
  }

  FirstPageHeaders({
    required this.oamAuthnCookie,
    required this.oamRequestContext,
    required this.gsisCookie,
    required this.nextUrl,
  });

  FirstPageHeaders.fromObject({required FirstPageHeaders headersObject})
      : nextUrl = headersObject.nextUrl,
        oamAuthnCookie = headersObject.oamAuthnCookie,
        oamRequestContext = headersObject.oamRequestContext,
        gsisCookie = headersObject.gsisCookie;

  String get cookies =>
      "gsis_cookie=$gsisCookie; OAMAuthnHintCookie=$oamAuthnCookie; OAMRequestContext_www1.aade.gr:443_$oamRequestContext;";

  static FirstPageHeaders getFromResponse(StreamedResponse streamedResponse) {
    final headers = streamedResponse.headers.toString();

    return FirstPageHeaders(
      gsisCookie: getBetweenStrings(headers, "gsis_cookie=", ";"),
      oamAuthnCookie: getBetweenStrings(headers, "OAMAuthnHintCookie=", ";"),
      oamRequestContext: getBetweenStrings(
          headers, "OAMRequestContext_www1.aade.gr:443_", ";"),
      nextUrl: Uri.parse(
        getBetweenStrings(headers, "location: ", ", date"),
      ),
    );
  }
}
