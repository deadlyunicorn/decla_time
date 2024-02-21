// ignore_for_file: avoid_print

import 'package:decla_time/declarations/utility/network_requests/get_user_properties.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/network_requests/login/login_user.dart';
import 'package:decla_time/declarations/utility/user_credentials.dart';
import 'package:flutter_test/flutter_test.dart';

import 'values.dart';

void main() async {
  test("Test that gets a list of the available property Ids", () async {

    final DeclarationsPageHeaders testingHeaders = await loginUser(
        credentials: UserCredentials(username: username, password: password));


    final userProperties = ( await getUserProperties(testingHeaders));
    if (userProperties.isEmpty) {
      throw "No properties found";
    } else {
      print("${userProperties.length} found!");
    }

    for ( int i = 0; i < userProperties.length; i++){
      print(userProperties[i].atak);
    print(userProperties[i].propertyId);
    print(userProperties[i].address);
    print(userProperties[i].serialNumber);

    expect(
        userProperties[i].atak.length, userProperties[i].propertyId.length);
    expect(userProperties[i].address.length,
        userProperties[i].propertyId.length);
    expect(userProperties[i].serialNumber.length,
        userProperties[i].propertyId.length);
    }
    
  });
}
