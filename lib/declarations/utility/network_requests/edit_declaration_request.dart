import 'package:decla_time/declarations/utility/declaration_body.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

Future<Response> editDeclarationRequest({
  required DeclarationsPageHeaders headersObject,
  required DeclarationBody declarationBody,
  required String viewState,
}) async {
  declarationAttemptResponse() async => await http.post(
        Uri.https(
          "www1.aade.gr",
          "taxisnet/short_term_letting/views/declaration.xhtml",
        ),
        headers: headersObject.getHeadersForPOST(),
        body: declarationBody.bodyStringPOST(viewState),
      );

  final res = (await declarationAttemptResponse());
  if (res.statusCode == 302) {
    print("our cookie timed out..");

    // headersObject.customSession( //?new session.. @Unimplemented.. TODO
    //   oamAuthnCookie:",
    // );
    // await declarationAttemptResponse(); //or do something recursive with delat() like await sendPaymentRequest();
  } else if (res.statusCode == 401) {
    print("jSessionId cookie expired");
  } else {
    print(res.statusCode);
  }

  return res;
}
