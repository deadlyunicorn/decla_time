import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:decla_time/declarations/functions/check_if_logged_in.dart';
import 'package:decla_time/declarations/utility/network_requests/get_user_properties_request.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';

Future<List<UserProperty>> getUserProperties(
  DeclarationsPageHeaders headers,
) async {
  final res = await getPropertiesRequest(
    headersObject: headers,
  );

  final body = res.body;
  checkIfLoggedIn(body); //! Can throw error

  return UserProperty.generateFromHtml(body);
}
