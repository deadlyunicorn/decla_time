import 'package:decla_time/declarations/database/declaration.dart';
import 'package:decla_time/declarations/utility/network_requests/get_declaration_db_id_from_declarations_list_page.dart';
import 'package:decla_time/declarations/utility/network_requests/get_declaration_search_page.dart';
import 'package:decla_time/declarations/utility/network_requests/get_user_properties.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/login_user.dart';
import 'package:decla_time/declarations/utility/search_page_data.dart';
import 'package:decla_time/declarations/utility/search_page_declaration.dart';
import 'package:decla_time/declarations/utility/user_credentials.dart';
import 'package:intl/intl.dart';

import 'values.dart';

void main() async {
  //?Test that extracts all the propertyIds from a

  final testingHeaders = await loginUser(
    credentials: UserCredentials(username: username, password: password),
  ); //? Is in .gitignore

  final departureDate = DateTime.now();
  final arrivalDate = DateFormat('dd/MM/y').parse("DAY/MONTH/YEAR");
  //! MAKE SURE TO SELECT A VALID RANGE THAT HAS NO MORE THAN ~7 declarations.. It will take a while..

  //* STEP 1:GETTING THE propertyId
  final propertyId = (await getUserProperties(testingHeaders))[0]
      .propertyId; //? Also checks if Logged In

  Future<bool> checkIfDeclarationExistsInDb(
      SearchPageDeclaration declaration) async {
    return false;
  }

  await importDeclarationsFromDateRangeFuture(
    arrivalDate: arrivalDate,
    departureDate: departureDate,
    propertyId: propertyId,
    headers: testingHeaders,
    checkIfDeclarationExistsInDb: checkIfDeclarationExistsInDb,
    storeDeclarationInDb: (p0)async {
      print("cool test");
    },
  );
}

Future<void> importDeclarationsFromDateRangeFuture({
  required DateTime arrivalDate,
  required DateTime departureDate,
  required String propertyId,
  required DeclarationsPageHeaders headers,
  required Future<bool> Function(SearchPageDeclaration)
      checkIfDeclarationExistsInDb,
  required Future<void> Function(Declaration) storeDeclarationInDb,
}) async {
  await setSearchPageDateRange(
    arrivalDate: arrivalDate,
    departureDate: departureDate,
    propertyId: propertyId,
    headers: headers,
  );

  SearchPageData currentSearchPageData = await getDeclarationSearchPage(
    headers: headers,
    propertyId: propertyId,
  );

  final rounds = (currentSearchPageData.total ~/ 50) + 1;

  DateTime nextArrivalDate =
      currentSearchPageData.declarations.last.arrivalDate;

  for (int j = 0; j < rounds; j++) {
    if (j > 0) {
      await setSearchPageDateRange(
        arrivalDate: nextArrivalDate,
        departureDate: departureDate,
        propertyId: propertyId,
        headers: headers,
      );
      currentSearchPageData = await getDeclarationSearchPage(
        headers: headers,
        propertyId: propertyId,
      );
      nextArrivalDate = currentSearchPageData.declarations.last.arrivalDate;
    }

    for (int i = 0; i < currentSearchPageData.declarations.length; i++) {
      SearchPageDeclaration currentDeclaration =
          currentSearchPageData.declarations[i];
      // print("ROUND $j, DECLARATION No. $i");

      await Future.delayed(const Duration(milliseconds: 500));

      {
        if (await checkIfDeclarationExistsInDb(currentDeclaration)) continue;
      }

      final SearchPageData searchPageData = await getDeclarationSearchPage(
        //?Used to get a new viewState for each propertyId
        headers: headers,
        propertyId: propertyId,
      );

      final declaration = await getDeclarationFromDeclarationsListPage(
        declarationIndex: i,
        headers: headers,
        parsedViewState: searchPageData.viewStateParsed,
        propertyId: propertyId,
      );

      await storeDeclarationInDb(declaration);
    }
  }
}
