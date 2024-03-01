import "package:decla_time/core/enums/booking_platform.dart";
import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/enums/declaration_type.dart";
import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/utility/declaration_body.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";

///? This is actually a POST request -
Future<DetailedDeclaration> getDeclarationFromSearchPageData({
  required String propertyId,
  required String parsedViewState,
  required int declarationIndex,
  required DeclarationStatus status,
  required DeclarationType declarationType,
  required DeclarationsPageHeaders headers,
}) async {
  final String declarationDbId = await http
      .post(
        Uri.https(
          "www1.aade.gr",
          "taxisnet/short_term_letting/views/declarationSearch.xhtml",
        ), //?Once the viewState has been used in a POST request -
        //? it can't be used again..
        body:
            // ignore: lines_longer_than_80_chars
            "javax.faces.ViewState=$parsedViewState&javax.faces.source=appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails&javax.faces.partial.ajax=true&javax.faces.partial.execute=%40all&appForm=appForm&appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails=appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails",
        headers: headers.getHeadersForPOST(),
      )
      .then(
        (http.Response res) =>
            getBetweenStrings(res.body, "declarationDbId=", '"'),
      );

  final http.Response res = await http.get(
    Uri.parse(
      "https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml?propertyId=$propertyId&declarationDbId=$declarationDbId",
    ),
    headers: headers.getHeadersForGET(),
  );

  final DateTime arrivalDate = DateFormat("dd/MM/y").parse(
    getBetweenStrings(
      res.body,
      'appForm:rentalFrom_input" type="text" value="',
      '"',
    ),
  );

  final int? serialNumber;

  final FinalizedDeclarationDetails? finalizedDeclarationDetails;
  if (status == DeclarationStatus.finalized) {
    final String declarationDetailsHtml = getBetweenStrings(
      res.body,
      '<fieldset id="appForm:j_idt35"',
      "</fieldset>",
    );

    serialNumber = int.parse(
      getBetweenStrings(
        declarationDetailsHtml,
        "S/N Declaration</td>\n<td> ",
        "</td>",
      ).trim(),
    );

    final DateTime declarationDate = DateFormat("dd/MM/y").parse(
      getBetweenStrings(
        declarationDetailsHtml,
        "Submission Date: </td>\n<td>",
        "</td>",
      ),
    );

    int? serialNumberOfAmendingDeclaration;

    if (declarationType == DeclarationType.amending) {
      final String amendmentDetailsHtml = getBetweenStrings(
        res.body,
        '<fieldset id="appForm:j_idt44"',
        "</fieldset>",
      );
      serialNumberOfAmendingDeclaration = int.parse(
        getBetweenStrings(
          amendmentDetailsHtml,
          "S/N Declaration</td>\n<td>",
          "</td>",
        ).trim(),
      );
    }

    finalizedDeclarationDetails = FinalizedDeclarationDetails(
      declarationDbId: int.parse(declarationDbId),
      declarationDate: declarationDate,
      declarationType: declarationType,
      serialNumber: serialNumber,
      serialNumberOfAmendingDeclaration: serialNumberOfAmendingDeclaration,
    );

  } else {
    serialNumber = null;
    finalizedDeclarationDetails = null;
  }

  final DateTime departureDate = DateFormat("dd/MM/y").parse(
    getBetweenStrings(
      res.body,
      'appForm:rentalTo_input" type="text" value="',
      '"',
    ),
  );
  final BookingPlatform platform = DeclarationBody.extractBookingPlatform(
    getBetweenStrings(
      getBetweenStrings(res.body, 'id="appForm:platform_input"', "</select>"),
      'selected="selected">',
      "</option>",
    ),
  );

  final double? payout = double.tryParse(
    getBetweenStrings(
      getBetweenStrings(res.body, "{id:'appForm:sumAmount',", "',"),
      "valueToRender:'",
      "0000",
    ),
  );

  final Declaration declaration = payout != null && payout > 0
      ? Declaration(
          serialNumber: serialNumber,
          propertyId: propertyId,
          declarationStatus: status,
          declarationDbId: int.tryParse(declarationDbId) ?? 0,
          bookingPlatform: platform,
          arrivalDate: arrivalDate,
          departureDate: departureDate,
          payout: payout,
        )
      : (() {
          final DateTime cancellationDate = DateFormat("dd/MM/y").parse(
            getBetweenStrings(
              res.body,
              'appForm:cancelDate_input" type="text" value="',
              '"',
            ),
          );
          final double? cancellationAmount = double.tryParse(
            getBetweenStrings(
              getBetweenStrings(res.body, "{id:'appForm:cancelAmount',", "',"),
              "valueToRender:'",
              "0000",
            ),
          );

          return Declaration(
            //? Declaration with cancellation
            serialNumber: serialNumber,
            declarationStatus: status,
            propertyId: propertyId,
            declarationDbId: int.tryParse(declarationDbId) ?? 0,
            bookingPlatform: platform,
            arrivalDate: arrivalDate,
            departureDate: departureDate,
            payout: 0,
            cancellationAmount: cancellationAmount,
            cancellationDate: cancellationDate,
          );
        })();

  return DetailedDeclaration(
    baseDeclaration: declaration,
    finalizedDeclarationDetails: finalizedDeclarationDetails,
  );
}

class DetailedDeclaration {
  final Declaration baseDeclaration;
  final FinalizedDeclarationDetails? finalizedDeclarationDetails;

  DetailedDeclaration({
    required this.baseDeclaration,
    required this.finalizedDeclarationDetails,
  });
}
