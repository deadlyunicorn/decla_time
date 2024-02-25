import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_search_page.dart";
import "package:decla_time/declarations/utility/network_requests/get_user_properties.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/search_page_data.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;

import "values.dart";

void main() async {
  test("Test that deletes a temporary declaration", () async {
    final DeclarationsPageHeaders testingHeaders = await loginUser(
      credentials: UserCredentials(username: username, password: password),
    );

    //* STEP 1:GETTING THE propertyId
    final String propertyId = (await getUserProperties(testingHeaders))[0]
        .propertyId; //? Also checks if Logged In

    //* STEP 2:GETTING the available declarations
    final SearchPageData declarationSearchPageDataBefore =
        await getDeclarationSearchPage(
      headers: testingHeaders,
      propertyId: propertyId,
    );

    final List<SearchPageDeclaration> temporaryDeclarationsBefore =
        declarationSearchPageDataBefore.declarations
            .where(
              (SearchPageDeclaration declaration) =>
                  declaration.status == DeclarationStatus.temporary,
            )
            .toList();

    if (temporaryDeclarationsBefore.isEmpty) throw "Can't delete - no entries";
    await ___TESTING___deleteTemporaryDeclarationFromSearchPage(
      searchPageDeclaration: temporaryDeclarationsBefore[0],
      headersObj: testingHeaders,
      viewState: declarationSearchPageDataBefore.viewStateParsed,
    );

    final SearchPageData declarationSearchPageDataAfter =
        await getDeclarationSearchPage(
      headers: testingHeaders,
      propertyId: propertyId,
    );
    final List<SearchPageDeclaration> temporaryDeclarationsAfter =
        declarationSearchPageDataAfter.declarations
            .where(
              (SearchPageDeclaration declaration) =>
                  declaration.status == DeclarationStatus.temporary,
            )
            .toList();

    // ignore: avoid_print
    print(
      // ignore: lines_longer_than_80_chars
      "Reservations before deletion: ${temporaryDeclarationsBefore.length}\nReservations after deletion: ${temporaryDeclarationsAfter.length}",
    );

    expect(
      temporaryDeclarationsAfter.length,
      temporaryDeclarationsBefore.length - 1,
    );
  });
}

// ignore: non_constant_identifier_names
Future<void> ___TESTING___deleteTemporaryDeclarationFromSearchPage({
  //? We will make a safer deletion with a DeclarationDbId for production.
  required SearchPageDeclaration searchPageDeclaration,
  required DeclarationsPageHeaders headersObj,
  required String viewState,
}) async {
  await http.post(
    Uri.parse(
      "https://www1.aade.gr/taxisnet/short_term_letting/views/declarationSearch.xhtml",
    ),
    body: searchPageDeclaration.deleteRequestBody(viewState),
    headers: headersObj.getHeadersForPOST(),
  );

  // print( deleteConfirmBody );

  await http.post(
    Uri.parse(
      "https://www1.aade.gr/taxisnet/short_term_letting/views/declarationSearch.xhtml",
    ),
    body: searchPageDeclaration.deleteConfirmationBody(viewState),
    headers: headersObj.getHeadersForPOST(),
  );
}
