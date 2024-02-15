import 'package:decla_time/declarations/functions/check_if_logged_in.dart';
import 'package:decla_time/declarations/utility/network_requests/get_user_properties.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/user_properties_information.dart';

Future<UserPropertiesInformation> getUserProperties(
  DeclarationsPageHeaders headers,
) async {
  final res = await getPropertiesRequest(
    headersObject: headers,
  );

  final body = res.body;
  checkIfLoggedIn(body); //! Can throw error

  return UserPropertiesInformation.generateFromHtml(body);
}
