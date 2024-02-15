import 'package:decla_time/core/extensions/get_values_between_strings.dart';
import 'package:decla_time/core/extensions/to_string_max_60.dart';

import 'fourth_page_headers.dart';
import 'package:http/http.dart';

class FifthPageHeaders extends FourthPageHeaders {

  @override
  // ignore: overridden_fields
  final Uri nextUrl = Uri.parse("https://www1.aade.gr/taxisnet/short_term_letting/");
  
  final String oamAuthnCookie;


  @override
  void printProperties() {
    super.printProperties();
    // ignore: avoid_print
    print("oamAuthnCookie:${oamAuthnCookie.toStringMax60}");
  }

  FifthPageHeaders({
    required this.oamAuthnCookie,
    required FourthPageHeaders previousPageHeaders,
  }) : super.fromObject(headersObject: previousPageHeaders);

  @override
  String get cookies =>
      "${super.cookies} OAMAuthnCookie_www1.aade.gr:443=$oamAuthnCookie;";

  static FifthPageHeaders getFromResponse({
    required StreamedResponse streamedResponse,
    required FourthPageHeaders previousPageHeaders,
  }) {
    final headers = streamedResponse.headers.toString();

    return FifthPageHeaders(
      oamAuthnCookie: getBetweenStrings(headers, "OAMAuthnCookie_www1.aade.gr:443=", ";"),
      previousPageHeaders: previousPageHeaders,
    );
  }
}
