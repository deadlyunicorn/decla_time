import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/functions/check_if_logged_in.dart";
import "package:decla_time/declarations/utility/declaration_body.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:http/http.dart" as http;

///Will throw `SuccessfullyFinalizedDeclarationException` on success.
Future<void> finalizeTemporaryDeclarationByDeclarationDbId({
  required DeclarationsPageHeaders headers,
  required String propertyId,
  required int declarationDbId,
  required Declaration declaration,
}) async {
  final String viewState = await http
      .get(
    Uri.parse(
      "https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml?propertyId=$propertyId&declarationDbId=$declarationDbId",
    ),
    headers: headers.getHeadersForGET(),
  )
      .then((http.Response res) {
    checkIfLoggedIn(res.body);
    return getBetweenStrings(res.body, 'ViewState" value="', '"');
  });

  await http
      .post(
    Uri.parse(
      "https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml",
    ),
    body: DeclarationBody(
      arrivalDate: declaration.arrivalDate,
      departureDate: declaration.departureDate,
      payout: declaration.payout,
      platform: declaration.bookingPlatform.toString(),
      cancellationDate: declaration.cancellationDate,
      cancellationAmount: declaration.cancellationAmount,
    ).bodyFINALIZEStringPOST(viewState),
    headers: headers.getHeadersForPOST(),
  )
      .then((http.Response res) {
    if (getBetweenStrings(
      res.body,
      '<td align="left"><div id="appForm:messages"',
      "</td>",
    ).contains("Επιτυχής Οριστικοποίηση Δήλωσης")) {
      throw SuccessfullyFinalizedDeclarationException();
    }
  });
}
