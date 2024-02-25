import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/utility/import_declarations_by_property_id.dart";
import "package:decla_time/declarations/utility/network_requests/get_user_properties.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:intl/intl.dart";

import "values.dart";

void main() async {
  //?Test that extracts all the propertyIds from a

  final DeclarationsPageHeaders testingHeaders = await loginUser(
    credentials: UserCredentials(username: username, password: password),
  ); //? Is in .gitignore

  final DateTime departureDate = DateTime.now();
  final DateTime arrivalDate = DateFormat("dd/MM/y").parse("DAY/MONTH/YEAR");
  //! MAKE SURE TO SELECT A VALID RANGE THAT HAS NO MORE THAN ~7 declarations.. 
  //! It will take a while..

  //* STEP 1:GETTING THE propertyId
  final String propertyId = (await getUserProperties(testingHeaders))[0]
      .propertyId; //? Also checks if Logged In

  Future<bool> checkIfDeclarationExistsInDb(
    SearchPageDeclaration declaration,
  ) async {
    return false;
  }

  await importDeclarationsFromDateRangeFuture(
    arrivalDate: arrivalDate,
    departureDate: departureDate,
    propertyId: propertyId,
    headers: testingHeaders,
    checkIfDeclarationExistsInDb: checkIfDeclarationExistsInDb,
    storeDeclarationInDb: (Declaration p0) async {
      // ignore: avoid_print
      print("cool test");
    },
  );
}
