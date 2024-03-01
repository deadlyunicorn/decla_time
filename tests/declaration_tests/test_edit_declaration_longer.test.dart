// ignore_for_file: avoid_print

import "package:decla_time/declarations/utility/declaration_body.dart";
import "package:decla_time/declarations/utility/network_requests/edit_declaration_request.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_details_from_search_page_data.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_page_view_state.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_search_page.dart";
import "package:decla_time/declarations/utility/network_requests/get_user_properties.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/search_page_data.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/src/response.dart";

import "values.dart";

void main() async {
  test("Test that edits a declaration", () async {
    //* STEP 0: GETTING THE necessary cookies
    //* the necessary cookies for editing declarations are:
    // ignore: lines_longer_than_80_chars
    //* JSESSIONID=; _WL_AUTHCOOKIE_JSESSIONID=; OAMAuthnCookie_www1.aade.gr:443=;

    //* STEP 1:GETTING THE propertyId
    //* We need to know the propertyId - we get this by going to the https://www1.aade.gr/taxisnet/short_term_letting/views/propertyRegistry/propertyRegistrySearch.xhtml

    //* STEP 2: GETTING THE declarationDbId
    //* We need to know the declarationDbId for editing an existing entry -
    //* We can store the declarationDbIds in our local database OR get new ones from https://www1.aade.gr/taxisnet/short_term_letting/views/declarationSearch.xhtml?propertyId=<propertyId>
    //! will consume viewState.

    //* STEP 2.1: In order to get declarations from specific dates -
    //* we need to send a POST request containing a viewState
    //* and our specified dates. - this will return html.

    //* STEP 3: GETTING THE viewState
    //* If we know both the propertyId and the declarationDbId
    //* then we can go to https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml?propertyId=<propertyId>declarationDbId=<declarationDbId>
    //* using our cookies.

    //? What if our authCookie expires during the operation..

    //* STEP 0: Getting the required cookies. -- Logging in User

    final DeclarationsPageHeaders testingHeaders = await loginUser(
      credentials: UserCredentials(
        username: username,
        password: password,
      ),
    ); //? Is in .gitignore

    //* STEP 1:GETTING THE propertyId
    final String propertyId = (await getUserProperties(testingHeaders))[0]
        .propertyId; //? Also checks if Logged In

    //* STEP 2:GETTING THE declarationDbId

    final SearchPageData declarationsSearchPageData =
        await getDeclarationSearchPage(
      headers: testingHeaders,
      propertyId: propertyId,
    );

    for (int i = 0; i < declarationsSearchPageData.declarations.length; i++) {
      declarationsSearchPageData.declarations[i].printData();
    }

    print("Select one: ");
    const String? userInput = null;
    final int selectedDeclarationIndex = int.parse(userInput ?? "0");
    print(
      // ignore: lines_longer_than_80_chars
      "Nvm io won't working during tests.. Selecting $selectedDeclarationIndex...",
    );

    final String declarationDbId = await getDeclarationFromSearchPageData(
      status: declarationsSearchPageData
          .declarations[selectedDeclarationIndex].status,
      declarationType: declarationsSearchPageData
          .declarations[selectedDeclarationIndex].type,
      propertyId: propertyId,
      declarationIndex: selectedDeclarationIndex,
      headers: testingHeaders,
      parsedViewState: declarationsSearchPageData.viewStateParsed,
    ).then(
      (DetailedDeclaration declaration) =>
          declaration.baseDeclaration.declarationDbId.toString(),
    );

    print("Your selected declaration has an id of: $declarationDbId");

    final Map<String, String> declarationQueryParameters = <String, String>{
      "propertyId": propertyId,
      "declarationDbId": declarationDbId,
    };

    //* STEP 3: GETTING THE viewState for the declaration edit page

    final String viewState = await getDeclarationPageViewState(
      declarationQueryParameters: declarationQueryParameters,
      testingHeaders: testingHeaders,
    );

    //* STEP 4: Edit the selected declaration

    final DeclarationBody newDeclarationBody = DeclarationBody(
      arrivalDate: DateTime.now(),
      departureDate: DateTime.now().add(const Duration(days: 2)),
      payout: 0.12,
      platform: "airbnb",
    );

    final Response res = await editDeclarationRequest(
      headersObject: testingHeaders,
      declarationBody: newDeclarationBody,
      viewState: viewState,
    );

    expect(
      res.body.contains(
        '<span class="ui-messages-info-detail">Επιτυχής Αποθήκευση</span>',
      ),
      true,
    );
  });
}
