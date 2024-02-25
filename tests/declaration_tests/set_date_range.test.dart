import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_search_page.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "values.dart";

void main() async {
  //? add in your browser cookies and see it changing.
  final DeclarationsPageHeaders testingHeaders = await loginUser(
    credentials: UserCredentials(username: username, password: password),
  );
  await setSearchPageDateRange(
    arrivalDate: DateTime.now(),
    departureDate: DateTime.now().add(const Duration(days: kMonthInDays)),
    propertyId: propertyId,
    headers: testingHeaders,
  );
}
