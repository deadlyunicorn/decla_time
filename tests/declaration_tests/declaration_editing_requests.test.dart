// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print

import 'package:decla_time/declarations/login/declaration_body.dart';
import 'package:decla_time/declarations/login/declarations_page_headers.dart';
import 'package:flutter_test/flutter_test.dart';

import 'edit_declaration_request.dart';
import 'values.dart';

void main() async {
  test("Test that edits a declaration", () async {

    final testingHeaders = DeclarationsPageHeaders( ///? Either use the login function or provide manual values.
      gsisCookie: "", 
      jSessionId: "",
      wl_authCookie_jSessionId: "",
    );

    final viewState = sampleViewState;  //* Change this for your tests

    final declarationBody = DeclarationBody(
      arrivalDate: DateTime.now(),
      departureDate: DateTime.now().add(const Duration(days: 2)),
      payout: 0.01,
      platform: "booking",
      viewState: viewState,
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
