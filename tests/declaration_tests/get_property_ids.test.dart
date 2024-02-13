// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'dart:io';

import 'package:decla_time/declarations/functions/check_if_logged_in.dart';
import 'package:decla_time/declarations/http_requests/get_user_properties.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_headers.dart';
import 'user_property_information.dart';

void main() async {
  test("Test that gets a list of the available property Ids", () async {
    final testingHeaders = await getTestHeaders(); 

    final res = await getPropertiesRequest(
      headersObject: testingHeaders,
    );

    final body = res.body;
    checkIfLoggedIn(body);

    final userProperties = UserPropertiesInformation.generateFromHtml(body);

    if (userProperties.propertyIds.isEmpty) {
      throw "No properties found";
    } else {
      print("${userProperties.propertyIds.length} found!");
    }

    print(userProperties.atakNumbers);
    print(userProperties.propertyIds);
    print(userProperties.addressOfProperties);
    print(userProperties.registryNumbers);

    print(res.statusCode);

    expect(
        userProperties.atakNumbers.length, userProperties.propertyIds.length);
    expect(userProperties.addressOfProperties.length,
        userProperties.propertyIds.length);
    expect(userProperties.registryNumbers.length,
        userProperties.propertyIds.length);
  });
}