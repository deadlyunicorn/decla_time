// ignore_for_file: non_constant_identifier_names

import 'get_values_between_strings.dart';
import 'login_test.dart';
import 'package:http/http.dart';
import 'second_page_headers.dart';

class ThirdPageHeaders extends SecondPageHeaders {
  @override
  // ignore: overridden_fields
  final String gsisCookie;

  @override
  // ignore: overridden_fields
  final Uri nextUrl = Uri.parse( "https://login.gsis.gr/oam/server/auth_cred_submit" );

  final String oam_JSESSIONID;
  //!SOS 
  final String oam_req_count = "VERSION_4~1";

  @override
  void printProperties() {
    super.printProperties();
    // ignore: avoid_print
    print("oam_JSESSIONID:${toStringMax60(oam_JSESSIONID)}");
  }

  ThirdPageHeaders({
    required this.gsisCookie,
    required this.oam_JSESSIONID,
    required SecondPageHeaders previousPageHeaders,
  }) : super.fromObject(headersObject: previousPageHeaders);

  @override
  String get cookies =>
      "${super.cookies} OAM_REQ_COUNT=$oam_req_count; OAM_JSESSIONID=$oam_JSESSIONID;";

  static ThirdPageHeaders getFromResponse({
    required StreamedResponse streamedResponse,
    required SecondPageHeaders previousPageHeaders,
  }) {
    final headers = streamedResponse.headers.toString();

    return ThirdPageHeaders(
      oam_JSESSIONID: getBetweenStrings(headers, "OAM_JSESSIONID=", ";"),
      gsisCookie: getBetweenStrings(headers, "gsis_cookie=", ";"),
      previousPageHeaders: previousPageHeaders,
    );
  }
}
