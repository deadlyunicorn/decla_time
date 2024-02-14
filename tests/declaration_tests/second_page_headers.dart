// ignore_for_file: non_constant_identifier_names

import 'get_values_between_strings.dart';
import 'first_page_headers.dart';
import 'package:http/http.dart';
import 'login_test.dart';

class SecondPageHeaders extends FirstPageHeaders {
  @override
  // ignore: overridden_fields
  final Uri nextUrl;
  final String oam_req_0;
  final String ecidContext;

  final String requestId;

  @override
  void printProperties() {
    super.printProperties();
    // ignore: avoid_print
    print("oam_req_0:${toStringMax60(oam_req_0)}");
    // ignore: avoid_print
    print("ecidContext:${toStringMax60(ecidContext)}");
    // ignore: avoid_print
    print("requestId:${toStringMax60(requestId)}");
  }

  SecondPageHeaders({
    required this.nextUrl,
    required this.requestId,
    required this.oam_req_0,
    required this.ecidContext,
    required FirstPageHeaders previousPageHeaders,
  }) : super.fromObject(headersObject: previousPageHeaders);

  SecondPageHeaders.fromObject({required SecondPageHeaders headersObject})
      : nextUrl = headersObject.nextUrl,
        requestId = headersObject.requestId,
        ecidContext = headersObject.ecidContext,
        oam_req_0 = headersObject.oam_req_0,
        super.fromObject(
          headersObject: headersObject,
        );

  @override
  String get cookies =>
      "${super.cookies} ECID-Context=$ecidContext; OAM_REQ_0=$oam_req_0;";

  static SecondPageHeaders getFromResponse({
    required StreamedResponse streamedResponse,
    required FirstPageHeaders previousPageHeaders,
  }) {
    final headers = streamedResponse.headers.toString();

    return SecondPageHeaders(
      oam_req_0: getBetweenStrings(headers, "OAM_REQ_0=", ";"),
      ecidContext: getBetweenStrings(headers, "ECID-Context=", ";"),
      nextUrl: Uri.parse(
        getBetweenStrings(headers, "location: ", ","),
      ),
      requestId: getBetweenStrings(headers, "&request_id=", "&"),
      previousPageHeaders: previousPageHeaders,
    );
  }
}

// final requestId =
  //     getValuesFromHtml(loginPageResponse.body, 'request_id" value="', '"')[0] ( getting it from html)
  //         .replaceAll(
  //   "&#45;",
  //   "-",
  // );
