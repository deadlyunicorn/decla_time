// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'package:decla_time/declarations/login/declaration_body.dart';
import 'package:flutter_test/flutter_test.dart';

import 'edit_declaration_request.dart';
import 'test_headers.dart';
import 'values.dart';

void main() async {
  test("Test that edits a declaration", () async {

    final testingHeaders = await getTestHeaders();

    final declarationBody = DeclarationBody(
      arrivalDate: DateTime.now(),
      departureDate: DateTime.now().add(const Duration(days: 2)),
      payout: 0.01,
      platform: "booking",
      viewState: sampleViewState,
    );

    final res = await editDeclarationRequest(
      headersObject: testingHeaders,
      bodyString: declarationBody.bodyString,
    );

    expect(
        res.body.contains(
            '<span class="ui-messages-info-detail">Επιτυχής Αποθήκευση</span>'),
        true);
  });
}
