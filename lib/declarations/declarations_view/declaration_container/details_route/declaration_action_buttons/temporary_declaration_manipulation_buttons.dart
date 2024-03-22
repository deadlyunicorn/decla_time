import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/check_if_logged_in.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/core/widgets/custom_alert_dialog.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/functions/resync_declaration.dart";
import "package:decla_time/declarations/utility/network_requests/delete_temporary_declaration_by_db_id.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_by_dbid.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class TemporaryDeclarationManipulationButtons extends StatelessWidget {
  const TemporaryDeclarationManipulationButtons({
    required this.localized,
    required this.declaration,
    required this.finalizedDeclarationDetails,
    super.key,
  });

  final AppLocalizations localized;
  final Declaration declaration;
  final FinalizedDeclarationDetails? finalizedDeclarationDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Tooltip(
          message: localized.deleteTemporaryDeclaration.capitalized,
          child: IconButton(
            onPressed: () async {
              final IsarHelper isarHelper = context.read<IsarHelper>();
              try {
                navigatorLoginIfNeeded(
                  context: context,
                  localized: localized,
                );
                showNormalSnackbar(
                  duration: const Duration(minutes: 1),
                  context: context,
                  message: "${localized.deleting.capitalized}...",
                );
                final DeclarationsPageHeaders headers =
                    context.read<UsersController>().loggedUser.headers!;
                await deleteTemporaryDeclarationByDeclarationDbId(
                  headers: headers,
                  propertyId: declaration.propertyId,
                  declarationDbId: declaration.declarationDbId,
                );
                await isarHelper.declarationActions
                    .removeFromDatabase(declaration.declarationDbId);
                if (context.mounted) {
                  Navigator.of(context).popUntil(
                    (Route<void> route) => route.isFirst,
                  );
                  ScaffoldMessenger.of(context).clearSnackBars();
                }
              } on NotLoggedInException {
                //
              }
            },
            icon: Icon(
              Icons.dangerous,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        Tooltip(
          message: "finalize",
          child: IconButton(
            onPressed: () async {
              navigatorLoginIfNeeded(context: context, localized: localized);
              try {
                await resyncDeclaration(
                  context: context,
                  detailedDeclaration: DetailedDeclaration(
                    baseDeclaration: declaration,
                    finalizedDeclarationDetails: finalizedDeclarationDetails,
                  ),
                  localized: localized,
                ); //? May throw `DeclarationWasUpdatedException`

                if (context.mounted) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => CustomAlertDialog(
                      confirmButtonAction: () {
                        print("sure?");
                      },
                      title: "Finalize declaration",
                      child: Text("no way normal fucking norwell"),
                      localized: localized,
                    ),
                  );
                }
              } on DeclarationWasUpdatedException {
                ///? Intended behaviour here.
              }

              //TODO Basically get a viewState and copy the same body with the differences and finialize.
//               fetch("https://www1.aade.gr/taxisnet/short_term_letting/views/declaration.xhtml", {
//   "headers": {
//     "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
//     "cookie": "/",
//   },
//   "body": "javax.faces.partial.ajax=true&javax.faces.source=appForm%3AfinalizeButton&javax.faces.partial.execute=%40all&javax.faces.partial.render=appForm&appForm%3AfinalizeButton=appForm%3AfinalizeButton&appForm=appForm&appForm%3ArentalFrom_input=14%2F02%2F2024&appForm%3ArentalTo_input=__DAY%2F__MONTH%2F__YEARFULL&appForm%3AsumAmount_input=MONEY_NON_DECIMAL%2CMONEY_AFTER_DEC&appForm%3AsumAmount_hinput=MONEY_PRE.MONEY_AFTER&appForm%3ApaymentType_input=4&appForm%3ApaymentType_focus=&appForm%3Aplatform_input=1&appForm%3Aplatform_focus=&appForm%3ArenterAfm=000000000&appForm%3AcancelAmount_input=&appForm%3AcancelAmount_hinput=&appForm%3AcancelDate_input=&appForm%3Aj_idt92=&javax.faces.ViewState=ViewState",
//   "method": "POST"
// });
            },
            icon: Icon(
              Icons.bookmarks_rounded,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }
}
