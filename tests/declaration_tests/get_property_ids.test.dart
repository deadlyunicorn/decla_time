// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'package:decla_time/declarations/functions/check_if_logged_in.dart';
import 'package:decla_time/declarations/http_requests/get_user_properties.dart';
import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_headers.dart';
import 'user_property_information.dart';

void main() async {
  test("Test that gets a list of the available property Ids", () async {
    final testingHeaders = await getTestHeaders();

    final userProperties = await getUserProperties(testingHeaders);
    if (userProperties.propertyIds.isEmpty) {
      throw "No properties found";
    } else {
      print("${userProperties.propertyIds.length} found!");
    }

    print(userProperties.atakNumbers);
    print(userProperties.propertyIds);
    print(userProperties.addressOfProperties);
    print(userProperties.registryNumbers);

    expect(
        userProperties.atakNumbers.length, userProperties.propertyIds.length);
    expect(userProperties.addressOfProperties.length,
        userProperties.propertyIds.length);
    expect(userProperties.registryNumbers.length,
        userProperties.propertyIds.length);
  });
}

Future<UserPropertiesInformation> getUserProperties(
  DeclarationsPageHeaders headers,
) async {
  final res = await getPropertiesRequest(
    headersObject: headers,
  );

  final body = res.body;
  print(res.statusCode);
  checkIfLoggedIn(body); //! Can throw error

  return UserPropertiesInformation.generateFromHtml(body);
}
