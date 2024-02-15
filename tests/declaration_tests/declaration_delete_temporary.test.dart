import 'package:decla_time/core/enums/declaration_status.dart';
import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_property_ids.test.dart';
import 'search_page_declaration.dart';
import 'test_edit_declaration_longer.test.dart';
import 'values.dart';
import 'package:http/http.dart' as http;

void main() async {
  test("Test that deletes a temporary declaration", () async {
    final testingHeaders = getTestHeaders();

    //* STEP 1:GETTING THE propertyId
    final propertyId = (await getUserProperties(testingHeaders))
        .propertyIds[0]; //? Also checks if Logged In

    //* STEP 2:GETTING the available declarations
    final declarationSearchPageDataBefore = await getDeclarationSearchPage(
      headers: testingHeaders,
      propertyId: propertyId,
    );

    final temporaryDeclarationsBefore = declarationSearchPageDataBefore
        .declarations
        .where(
            (declaration) => declaration.status == DeclarationStatus.temporary)
        .toList();

    if (temporaryDeclarationsBefore.isEmpty) throw "Can't delete - no entries";
    await deleteTemporaryDeclarationFromSearchPage(
      searchPageDeclaration: temporaryDeclarationsBefore[0],
      headersObj: testingHeaders,
      viewState: declarationSearchPageDataBefore.viewStateParsed,
    );

    final declarationSearchPageDataAfter = await getDeclarationSearchPage(
      headers: testingHeaders,
      propertyId: propertyId,
    );
    final temporaryDeclarationsAfter = declarationSearchPageDataAfter
        .declarations
        .where(
            (declaration) => declaration.status == DeclarationStatus.temporary)
        .toList();

    print(
        "Reservations before deletion: ${temporaryDeclarationsBefore.length}\nReservations after deletion: ${temporaryDeclarationsAfter.length}");

    expect(
      temporaryDeclarationsAfter.length,
      temporaryDeclarationsBefore.length - 1,
    );
  });
}

Future<void> deleteTemporaryDeclarationFromSearchPage({
  required SearchPageDeclaration searchPageDeclaration,
  required DeclarationsPageHeaders headersObj,
  required String viewState,
}) async {
  await http.post(
    Uri.parse(
        "https://www1.aade.gr/taxisnet/short_term_letting/views/declarationSearch.xhtml"),
    body: searchPageDeclaration.deleteRequestBody(viewState),
    headers: headersObj.getHeadersForPOST(),
  );

  // print( deleteConfirmBody );

  await http.post(
    Uri.parse(
        "https://www1.aade.gr/taxisnet/short_term_letting/views/declarationSearch.xhtml"),
    body: searchPageDeclaration.deleteConfirmationBody(viewState),
    headers: headersObj.getHeadersForPOST(),
  );
}
