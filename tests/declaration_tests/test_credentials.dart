// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'get_values_from_html.dart';

Future<UserCredentials> getCredentialsFromFile(File file) async {
  final fileContent = await file.readAsString();

  final username = getValuesFromHtml(fileContent, ">username:", ";")[0];
  final password = getValuesFromHtml(fileContent, ">password:", ";")[0];

  return UserCredentials(username: username, password: password);
}

void main() {
  test("getting credentials from file", () async {
    final sampleFile = File("credentialsSample.txt");
    final credentials = await getCredentialsFromFile(sampleFile);

    expect(credentials.username, "sampleUsername");
    expect(credentials.password, "samplePassword");
  });
}

class UserCredentials {
  final String _username;
  final String _password;

  UserCredentials({required String username, required String password})
      : _username = username,
        _password = password;

  get username => _username;
  get password => _password;
}
