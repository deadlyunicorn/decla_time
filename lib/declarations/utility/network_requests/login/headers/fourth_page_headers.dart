// ignore_for_file: non_constant_identifier_names

import 'package:decla_time/core/extensions/get_values_between_strings.dart';
import 'package:decla_time/core/extensions/to_string_max_60.dart';
import 'package:http/http.dart';
import 'third_page_headers.dart';

class FourthPageHeaders extends ThirdPageHeaders {
  @override
  // ignore: overridden_fields
  final Uri nextUrl;

  final String oam_id;

  @override
  // ignore: overridden_fields
  final ecidContext = ""; //? It gets removed with this request.
  @override
  // ignore: overridden_fields
  final oam_req_0 = "";

  @override
  void printProperties() {
    super.printProperties();
    // ignore: avoid_print
    print("OAM_ID:${oam_id.toStringMax60}");
  }

  FourthPageHeaders({
    // required this.gsisCookie,
    required this.oam_id,
    required this.nextUrl,
    required ThirdPageHeaders previousPageHeaders,
  }) : super.fromObject(headersObject: previousPageHeaders);

  FourthPageHeaders.fromObject({required FourthPageHeaders headersObject})
      : oam_id = headersObject.oam_id,
        nextUrl = headersObject.nextUrl,
        // gsisCookie = headersObject.gsisCookie,
        super.fromObject(headersObject: headersObject);

  @override
  String get cookies => "${super.cookies} OAM_ID=$oam_id;";

  static FourthPageHeaders getFromResponse({
    required String firstPageGsisCookie,
    required StreamedResponse streamedResponse,
    required ThirdPageHeaders previousPageHeaders,
  }) {
    final headers = streamedResponse.headers.toString();

    return FourthPageHeaders(
      // gsisCookie: firstPageGsisCookie,
      oam_id: getBetweenStrings(headers, "OAM_ID=", ";"),
      nextUrl: Uri.parse(getBetweenStrings(headers, "location: ", ",")),
      previousPageHeaders: previousPageHeaders,
    );
  }
}
