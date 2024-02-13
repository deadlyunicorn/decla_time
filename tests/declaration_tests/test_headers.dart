import 'package:decla_time/declarations/login/declarations_page_headers.dart';

DeclarationsPageHeaders getTestHeaders(){

  final testingHeaders = DeclarationsPageHeaders(
      gsisCookie:
          "<get from file>",
      wl_authCookie_jSessionId: "<get from file>",
      jSessionId:
          "<get from file>",
    );

    testingHeaders.newSession(
      oamAuthnCookie:
          "<get from file>",
    );

    return testingHeaders;
}