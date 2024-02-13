// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_values_from_html.dart';
import 'values.dart';

Future<DeclarationsPageHeaders> getTestHeaders() async {
  
  final testingHeaders = DeclarationsPageHeaders(
    gsisCookie: gsisCookie,
    wl_authCookie_jSessionId: wl_authCookie_jSessionId,
    jSessionId: jSessionId,
  );

  testingHeaders.newSession(
    oamAuthnCookie: oamAuthnCookie,
  );

  return testingHeaders;
}



Future<DeclarationsPageHeaders> getTestHeadersFromFileFuture(File file) async {
  final fileContent = await file.readAsString();

  final gsisCookie = getValuesFromHtml(fileContent, ">gsisCookie:", ";")[0];
  final wl_authCookie_jSessionId =
      getValuesFromHtml(fileContent, ">wl_authCookie_jSessionId:", ";")[0];
  final jSessionId = getValuesFromHtml(fileContent, ">jSessionId:", ";")[0];
  final oamAuthnCookie =
      getValuesFromHtml(fileContent, ">oamAuthnCookie:", ";")[0];

  final testingHeaders = DeclarationsPageHeaders(
    gsisCookie: gsisCookie,
    wl_authCookie_jSessionId: wl_authCookie_jSessionId,
    jSessionId: jSessionId,
  );

  testingHeaders.newSession(
    oamAuthnCookie: oamAuthnCookie,
  );

  return testingHeaders;
}

void main() {
  test("getting headers from file", () async {
    final sampleFile = File("headersSample.txt");
    final headers = await getTestHeadersFromFileFuture(sampleFile);

    expect(headers.gsisCookie, "thisIsGsis");
    expect(headers.oamAuthnCookie, "thisIsOam");
    expect(headers.jSessionId, "thisIsJsessionId");
    expect(headers.wl_authCookie_jSessionId, "ThisIsWl_auth");
  });
}
