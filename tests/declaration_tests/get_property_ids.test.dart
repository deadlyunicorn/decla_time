// ignore_for_file: avoid_print

import 'package:decla_time/declarations/utility/network_requests/get_user_properties_request.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/login_user.dart';
import 'package:decla_time/declarations/utility/user_credentials.dart';
import 'package:flutter_test/flutter_test.dart';

import 'values.dart';

void main() async {
  test("Test that gets a list of the available property Ids", () async {

    final DeclarationsPageHeaders testingHeaders = await loginUser(
        credentials: UserCredentials(username: username, password: password));


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
