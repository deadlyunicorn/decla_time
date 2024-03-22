import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/check_if_logged_in.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_by_dbid.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

///If updated, throws `DeclarationWasUpdatedException`
Future<void> resyncDeclaration({
  required BuildContext context,
  required DetailedDeclaration detailedDeclaration,
  required AppLocalizations localized,
}) async {
  final UsersController usersController = context.read<UsersController>();
  final IsarHelper isarHelper = context.read<IsarHelper>();

  try {
    navigatorLoginIfNeeded(
      context: context,
      localized: localized,
    ); //* Throws error if not logged in
    showNormalSnackbar(
      context: context,
      message: "${localized.synchronizing.capitalized}...",
    );
    bool needsUpdate = false;

    final DetailedDeclaration cloudDeclaration = await getDeclarationByDbId(
      headers: usersController.loggedUser.headers!,
      propertyId: detailedDeclaration.baseDeclaration.propertyId,
      declarationDbId: detailedDeclaration.baseDeclaration.declarationDbId,
    );

    if (cloudDeclaration.finalizedDeclarationDetails != null &&
        detailedDeclaration.finalizedDeclarationDetails != null) {
      if (!cloudDeclaration.finalizedDeclarationDetails!.isEqualTo(
        detailedDeclaration.finalizedDeclarationDetails!,
      )) {
        needsUpdate = true;
      }
    } else if (detailedDeclaration.finalizedDeclarationDetails == null &&
        cloudDeclaration.finalizedDeclarationDetails != null) {
      needsUpdate = true;
    } else if (!detailedDeclaration.baseDeclaration
        .isEqualTo(cloudDeclaration.baseDeclaration)) {
      needsUpdate = true;
    }

    if (needsUpdate) {
      await isarHelper.declarationActions.insertMultipleEntriesToDb(
        <Declaration>[cloudDeclaration.baseDeclaration],
      );
      if (cloudDeclaration.finalizedDeclarationDetails != null) {
        await isarHelper.declarationActions
            .insertMultipleFinalizedDeclarationsToDb(
          <FinalizedDeclarationDetails>[
            cloudDeclaration.finalizedDeclarationDetails!,
          ],
        );
      }
      if (context.mounted) {
        showNormalSnackbar(
          context: context,
          message: localized.declarationWasUpdated.capitalized,
        );
        throw DeclarationWasUpdatedException();
      }
    }
  } on InvalidDeclarationException {
    if (context.mounted) {
      showErrorSnackbar(
        context: context,
        message: localized.noValidDeclarationFound.capitalized,
      );
    }
  }
}
