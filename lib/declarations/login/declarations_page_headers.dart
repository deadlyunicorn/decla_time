// ignore_for_file: prefer_const_declarations, non_constant_identifier_names

class DeclarationsPageHeaders {
  final String gsisCookie;
  final String wl_authCookie_jSessionId;
  final String jSessionId;
  String? oamAuthnCookie;

  void newSession({required String oamAuthnCookie}) {
    this.oamAuthnCookie = oamAuthnCookie;
  }

  DeclarationsPageHeaders({
    required this.gsisCookie,
    required this.wl_authCookie_jSessionId,
    required this.jSessionId,
  });

  //if requestStatus == 302, we need to refresh the `OAMAuthnCookie_www1.aade.gr:443` cookie
  Map<String, String> getHeadersForGET() {
    if (oamAuthnCookie == null) {
      //Or if we get a 302 response throw we need a new session.
      throw "You need to get a new session!";
    } else {
      return {
        "cookie":
            "JSESSIONID=$jSessionId; _WL_AUTHCOOKIE_JSESSIONID=$wl_authCookie_jSessionId; OAMAuthnCookie_www1.aade.gr:443=$oamAuthnCookie",
        //NOT NEEDED FOR EDITING A DECLARATION: gsis_cookie=$gsisCookie;
      };
    }
  }

  Map<String, String> getHeadersForPOST() {
    return getHeadersForGET()
      ..addAll({
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
      });
  }
}
