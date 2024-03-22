import "package:decla_time/core/enums/booking_platform.dart";
import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/enums/declaration_type.dart";
import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/utility/declaration_body.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";

///Can throw `InvalidDeclarationException`.
Future<DetailedDeclaration> getDeclarationByDbId({
  required DeclarationsPageHeaders headers,
  required String propertyId,
  required int declarationDbId,
}) async {
  final http.Response res = await http.get(
    Uri.parse(
      "https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml?propertyId=$propertyId&declarationDbId=$declarationDbId",
    ),
    headers: headers.getHeadersForGET(),
  );

  try {
    final FinalizedDeclarationDetails? finalizedDeclarationDetails =
        extractFinalizedDeclarationFromDeclarationPage(
      html: res.body,
      declarationDbId: declarationDbId,
    );

    final DeclarationStatus declarationStatus;

    if (finalizedDeclarationDetails == null) {
      declarationStatus = DeclarationStatus.temporary;
    } else {
      declarationStatus = DeclarationStatus.finalized;
    }

    final Declaration declaration = extractDeclarationFromDeclarationPage(
      html: res.body,
      serialNumber: finalizedDeclarationDetails?.serialNumber,
      status: declarationStatus,
      propertyId: propertyId,
      declarationDbId: declarationDbId,
    );

    return DetailedDeclaration(
      baseDeclaration: declaration,
      finalizedDeclarationDetails: finalizedDeclarationDetails,
    );
  } on FormatException {
    throw InvalidDeclarationException();
  } on UnknownErrorException {
    throw InvalidDeclarationException();
  }
}

class DetailedDeclaration {
  final Declaration baseDeclaration;
  final FinalizedDeclarationDetails? finalizedDeclarationDetails;

  DetailedDeclaration({
    required this.baseDeclaration,
    required this.finalizedDeclarationDetails,
  });
}

Declaration extractDeclarationFromDeclarationPage({
  required String html,
  required int? serialNumber,
  required DeclarationStatus status,
  required String propertyId,
  required int declarationDbId,
}) {
  final DateTime arrivalDate = DateFormat("dd/MM/y").parse(
    getBetweenStrings(
      html,
      'appForm:rentalFrom_input" type="text" value="',
      '"',
    ),
  );

  final DateTime departureDate = DateFormat("dd/MM/y").parse(
    getBetweenStrings(
      html,
      'appForm:rentalTo_input" type="text" value="',
      '"',
    ),
  );
  final BookingPlatform platform = DeclarationBody.extractBookingPlatform(
    getBetweenStrings(
      getBetweenStrings(html, 'id="appForm:platform_input"', "</select>"),
      'selected="selected">',
      "</option>",
    ),
  );

  final double? payout = double.tryParse(
    getBetweenStrings(
      getBetweenStrings(html, "{id:'appForm:sumAmount',", "',"),
      "valueToRender:'",
      "0000",
    ),
  );

  if (payout != null && payout > 0) {
    return Declaration(
      serialNumber: serialNumber,
      propertyId: propertyId,
      declarationStatus: status,
      declarationDbId: declarationDbId,
      bookingPlatform: platform,
      arrivalDate: arrivalDate,
      departureDate: departureDate,
      payout: payout,
    );
  } else {
    final DateTime cancellationDate = DateFormat("dd/MM/y").parse(
      getBetweenStrings(
        html,
        'appForm:cancelDate_input" type="text" value="',
        '"',
      ),
    );
    final double? cancellationAmount = double.tryParse(
      getBetweenStrings(
        getBetweenStrings(html, "{id:'appForm:cancelAmount',", "',"),
        "valueToRender:'",
        "0000",
      ),
    );

    return Declaration(
      //? Declaration with cancellation
      serialNumber: serialNumber,
      declarationStatus: status,
      propertyId: propertyId,
      declarationDbId: declarationDbId,
      bookingPlatform: platform,
      arrivalDate: arrivalDate,
      departureDate: departureDate,
      payout: 0,
      cancellationAmount: cancellationAmount,
      cancellationDate: cancellationDate,
    );
  }
}

FinalizedDeclarationDetails? extractFinalizedDeclarationFromDeclarationPage({
  required String html,
  required int declarationDbId,
}) {
  final DeclarationType declarationType;
  final int? serialNumberOfAmendingDeclaration;

  final List<String> userMainTables = getAllBetweenStrings(
    html,
    '<table class="userMainTable">',
    "</table>",
  )
      .where(
        (String element) =>
            element.contains(
              "Στοιχεία Δήλωσης / Declaration Details",
            ) ||
            element.contains(
              "Δήλωση που τροποποιείται / Amending Declaration Details",
            ),
      )
      .toList();

  if (userMainTables.length == 1) {
    declarationType = DeclarationType.initial;
    serialNumberOfAmendingDeclaration = null;
  } else if (userMainTables.length == 2) {
    declarationType = DeclarationType.amending;
    serialNumberOfAmendingDeclaration = int.parse(
      getBetweenStrings(
        userMainTables[1],
        "S/N Declaration</td>\n<td>",
        "</td>",
      ).trim(),
    );
  } else {
    throw UnknownErrorException();
  }

  final int? serialNumber = int.tryParse(
    getBetweenStrings(
      userMainTables.first,
      "S/N Declaration</td>\n<td> ",
      "</td>",
    ).trim(),
  );

  if (serialNumber == null) {
    return null;
  } else {
    final DateTime declarationDate = DateFormat("dd/MM/y").parse(
      getBetweenStrings(
        userMainTables.first,
        "Submission Date: </td>\n<td>",
        "</td>",
      ),
    );

    return FinalizedDeclarationDetails(
      declarationDbId: declarationDbId,
      declarationDate: declarationDate,
      declarationType: declarationType,
      serialNumber: serialNumber,
      serialNumberOfAmendingDeclaration: serialNumberOfAmendingDeclaration,
    );
  }
}
