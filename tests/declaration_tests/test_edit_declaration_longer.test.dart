// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print, dead_code


import 'package:decla_time/declarations/login/declaration_body.dart';
import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'declaration_list_page_data.dart';
import 'edit_declaration_request.dart';
import 'get_property_ids.test.dart';
import 'get_values_between_strings.dart';
import 'test_headers.dart';

void main() async {
  test("Test that edits a declaration", () async {
    //* STEP 0: GETTING THE necessary cookies
    //* the necessary cookies for editing declarations are:
    //* JSESSIONID=; _WL_AUTHCOOKIE_JSESSIONID=; OAMAuthnCookie_www1.aade.gr:443=;

    //* STEP 1:GETTING THE propertyId
    //* We need to know the propertyId - we get this by going to the https://www1.aade.gr/taxisnet/short_term_letting/views/propertyRegistry/propertyRegistrySearch.xhtml

    //* STEP 2: GETTING THE declarationDbId
    //* We need to know the declarationDbId for editing an existing entry -
    //* We can store the declarationDbIds in our local database OR get new ones from https://www1.aade.gr/taxisnet/short_term_letting/views/declarationSearch.xhtml?propertyId=<propertyId>
    //! will consume viewState.

    //* STEP 2.1: In order to get declarations from specific dates -  we need to send a POST request containing a viewState and our specified dates. - this will return html.

    //* STEP 3: GETTING THE viewState
    //* If we know both the propertyId and the declarationDbId
    //* then we can go to https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml?propertyId=<propertyId>declarationDbId=<declarationDbId>
    //* using our cookies.

    //? What if our authCookie expires during the operation..

    //* STEP 0: Getting the required cookies.
    // final credentials = LoginBodyFields(username: username, password: password);
    // throw UnimplementedError();



    final testingHeaders = await getTestHeaders(); //? Is in .gitignore



    //* STEP 1:GETTING THE propertyId
    final propertyId = (await getUserProperties(testingHeaders))
        .propertyIds[0]; //? Also checks if Logged In

    //* STEP 2:GETTING THE declarationDbId

    final declarationsList = await getDeclarationListData(
      headers: testingHeaders,
      propertyId: propertyId,
    );

    if (declarationsList.arrivalDates.length != declarationsList.departureDates.length) {
      throw "Invalid data";
    }
    for (int i = 0; i < declarationsList.arrivalDates.length; i++) {
      print(
          "$i. ${declarationsList.arrivalDates[i]} - ${declarationsList.departureDates[i]} | ${declarationsList.payouts[i]} EUR");
    }

    print("Select one: ");
    final String? userInput = null;
    final int selectedDeclarationIndex = int.parse(userInput ?? "0");
    print("Nvm io won't working during tests.. Selecting $selectedDeclarationIndex...");
    
    final declarationDbId = await getDeclarationDbIdFromDeclarationsListPage(
      declarationIndex: selectedDeclarationIndex,
      headers: testingHeaders,
      parsedViewState: declarationsList.viewStateParsed
    );

    print( "Your selected declaration has an id of: $declarationDbId" );


    final declarationQueryParameters = {
      "propertyId": propertyId,
      "declarationDbId": declarationDbId
    };

    //* STEP 3: GETTING THE viewState for the declaration edit page

    final viewState = await getDeclarationViewState(
      declarationQueryParameters,
      testingHeaders,
    );

    //* STEP 4: Edit the selected declaration

    final newDeclarationBody = DeclarationBody(
      arrivalDate: DateTime.now(),
      departureDate: DateTime.now().add(const Duration(days: 2)),
      payout: 0.06,
      platform: "booking",
      viewState: viewState,
    );

    final res = await editDeclarationRequest(
      headersObject: testingHeaders,
      bodyString: newDeclarationBody.bodyString,
    );

    expect(
        res.body.contains(
            '<span class="ui-messages-info-detail">Επιτυχής Αποθήκευση</span>'),
        true);
  });
}

Future<String> getDeclarationViewState(
  Map<String, String> declarationQueryParameters,
  DeclarationsPageHeaders testingHeaders,
) async {
  return await http
      .get(
    Uri.https(
      "www1.aade.gr",
      "taxisnet/short_term_letting/views/declaration.xhtml",
      declarationQueryParameters,
    ),
    headers: testingHeaders.getHeaders(),
  )
      .then(
    (res) {
      final body = res.body;
      return getAllBetweenStrings(
          body, 'id="javax.faces.ViewState" value="', '"')[0];
    },
  );
}

Future<DeclarationListPageData> getDeclarationListData(
    {required DeclarationsPageHeaders headers,
    required String propertyId}) async {
  return await http
      .get(
    Uri.https(
      "www1.aade.gr",
      "taxisnet/short_term_letting/views/declarationSearch.xhtml",
      {"propertyId": propertyId},
    ),
    headers: headers.getHeaders(),
  )
      .then((res) {
    return DeclarationListPageData.getFromHtml(res.body);
  });
}

Future<String> getDeclarationDbIdFromDeclarationsListPage(
    {required String parsedViewState,
    required int declarationIndex,
    required DeclarationsPageHeaders headers}) async {
  return await http
      .post(
        Uri.https(
          "www1.aade.gr",
          "taxisnet/short_term_letting/views/declarationSearch.xhtml",
        ), //?Once the viewState has been used in a POST request - it can't be used again..
        body:
            "${parsedViewState}javax.faces.source=appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails&javax.faces.partial.ajax=true&javax.faces.partial.execute=%40all&appForm=appForm&appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails=appForm%3AbasicDT%3A$declarationIndex%3AdeclarationDetails",
        headers: headers.getHeaders(),
      )
      .then((res) => getAllBetweenStrings(res.body, "declarationDbId=", '"')[0]);
}
