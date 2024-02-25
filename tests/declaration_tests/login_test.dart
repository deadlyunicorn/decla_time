import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;

import "values.dart";

void main() async {
  test(
    "Test that logins to the service and retrieves cookies",
    () async {
      final DeclarationsPageHeaders requiredSessionCookies = await loginUser(
        credentials: UserCredentials(username: username, password: password),
      );
      final String declarationsPage = await http
          .get(
            Uri.https("www1.aade.gr", "taxisnet/short_term_letting"),
            headers: requiredSessionCookies.getHeadersForGET(),
          )
          .then(
            (http.Response res) => res.body,
          );

      expect(requiredSessionCookies.oamAuthnCookie?.endsWith("%3D"), true);
      expect(
        declarationsPage
            .contains("<title>Μητρώο Ακινήτων Βραχυχρόνιας Διαμονής</title>"),
        true,
      );
    },
  );
}
