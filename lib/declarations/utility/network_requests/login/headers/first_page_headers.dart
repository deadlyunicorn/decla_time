import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:decla_time/core/extensions/to_string_max_60.dart";
import "package:http/http.dart";

class FirstPageHeaders {
  final String oamAuthnHintCookie;
  final String oamRequestContext;
  String gsisCookie;
  final Uri nextUrl;

  void printProperties() {
    // ignore: avoid_print
    print("oamAuthnHintCookie:${oamAuthnHintCookie.toStringMax60}");
    // ignore: avoid_print
    print("oamRequestContext:${oamRequestContext.toStringMax60}");
    // ignore: avoid_print
    print("gsisCookie:${gsisCookie.toStringMax60}");
    // ignore: avoid_print
    print("nextUrl:${nextUrl.toStringMax60}");
  }

  FirstPageHeaders({
    required this.oamAuthnHintCookie,
    required this.oamRequestContext,
    required this.gsisCookie,
    required this.nextUrl,
  });

  FirstPageHeaders.fromObject({required FirstPageHeaders headersObject})
      : nextUrl = headersObject.nextUrl,
        oamAuthnHintCookie = headersObject.oamAuthnHintCookie,
        oamRequestContext = headersObject.oamRequestContext,
        gsisCookie = headersObject.gsisCookie;

  String get cookies =>
      // ignore: lines_longer_than_80_chars
      "gsis_cookie=$gsisCookie; OAMAuthnHintCookie=$oamAuthnHintCookie; OAMRequestContext_www1.aade.gr:443_$oamRequestContext;";

  static FirstPageHeaders getFromResponse(StreamedResponse streamedResponse) {
    final String headers = streamedResponse.headers.toString();

    return FirstPageHeaders(
      gsisCookie: getBetweenStrings(headers, "gsis_cookie=", ";"),
      oamAuthnHintCookie:
          getBetweenStrings(headers, "OAMAuthnHintCookie=", ";"),
      oamRequestContext: getBetweenStrings(
          headers, "OAMRequestContext_www1.aade.gr:443_", ";",),
      nextUrl: Uri.parse(
        getBetweenStrings(headers, "location: ", ", date"),
      ),
    );
  }
}
