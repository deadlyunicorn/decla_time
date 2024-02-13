// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() async {
  test("Test that logins to the service and retrieves cookies", () async {
    final res = await executeProgramm1();
    expect(res.statusCode, 200); //TODO make an actual test.
  });
}

Future<Response> executeProgramm1() {
  print("fetching..");

  final username = "get from file";
  final password = "get from file";
  final requestId = "random";

  return http.post(Uri.https('login.gsis.gr', 'oam/server/auth_cred_submit'),
      body:
          "request_id=$requestId&username=$username&password=$password&btn_login=",
      headers: {
        "content-type": "application/x-www-form-urlencoded",
        "cookie":
            "OAM_REQ_0=; OAM_REQ_COUNT=; ECID-Context=; gsis_cookie=${"b" /*TODO*/}; OAM_JSESSIONID=${"a" /*TODO*/}",
        // "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
        // "cache-control": "max-age=0",
        // "sec-fetch-mode": "navigate",
        // "Referrer-Policy": "strict-origin-when-cross-origin",
        // Referer: reffererUrl,
      });


  // print(response.body);
  // http
}
