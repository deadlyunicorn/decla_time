// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

Future<Response> editDeclarationRequest({
  required DeclarationsPageHeaders headersObject,
  required String bodyString,
}) async {
  declarationAttemptResponse() async => await http.post(
        Uri.https(
          "www1.aade.gr",
          "taxisnet/short_term_letting/views/declaration.xhtml",
        ),
        headers: headersObject.getHeaders(),
        body: bodyString,
      );

  final res = (await declarationAttemptResponse());
  if (res.statusCode == 302) {
    print("our cookie timed out..");

    // headersObject.customSession( //?new session.. @Unimplemented..
    //   oamAuthnCookie:",
    // );
    // await declarationAttemptResponse(); //or do something recursive with delat() like await sendPaymentRequest();
  } else if (res.statusCode == 401) {
    print("jSessionId cookie expired");
  } else {
    print(res.statusCode);
  }

  return res;
}
