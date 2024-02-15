// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'package:decla_time/declarations/login/declaration_body.dart';
import 'package:flutter_test/flutter_test.dart';

import 'edit_declaration_request.dart';
import 'values.dart';

void main() async {
  test("Test that edits a declaration", () async {
    final testingHeaders = getTestHeaders(); //?From values.dart
    final viewStateParsed = //?from sample
        "${sampleViewState.split(":")[0]}%3A${sampleViewState.split(":")[1]}"; //* Change this for your tests

    final declarationBody = DeclarationBody(
      arrivalDate: DateTime.now(),
      departureDate: DateTime.now().add(const Duration(days: 2)),
      payout: 0.01,
      platform: "booking",
    );

    final res = await editDeclarationRequest(
      headersObject: testingHeaders,
      bodyString: declarationBody.bodyStringPOST(viewStateParsed),
    );

    expect(
        res.body.contains(
            '<span class="ui-messages-info-detail">Επιτυχής Αποθήκευση</span>'),
        true);
  });
}
