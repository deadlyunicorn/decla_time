import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_by_dbid.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class ResyncDeclarationButton extends StatelessWidget {
  const ResyncDeclarationButton({
    required this.localized,
    required this.declaration,
    required this.declarationDetails,
    super.key,
  });

  final AppLocalizations localized;
  final Declaration declaration;
  final FinalizedDeclarationDetails? declarationDetails;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: localized.sync.capitalized,
      child: IconButton(
        onPressed: () async {
          await resyncDeclaration(context);
        },
        icon: const Icon(Icons.refresh),
      ),
    );
  }

  Future<void> resyncDeclaration(BuildContext context) async {
    final UsersController usersController = context.read<UsersController>();
    final IsarHelper isarHelper = context.read<IsarHelper>();

    if (usersController.loggedUser.headers == null) {
      usersController.setRequestLogin(true);
      Navigator.popUntil(
        context,
        (Route<void> route) => route.isFirst,
      );
      showErrorSnackbar(
        context: context,
        message: localized.notLoggedIn.capitalized,
      );
    } else {
      showNormalSnackbar(
        context: context,
        message: localized.synchronizing.capitalized,
      );
      bool needsUpdate = false;

      final DetailedDeclaration cloudDeclaration = await getDeclarationByDbId(
        headers: usersController.loggedUser.headers!,
        propertyId: declaration.propertyId,
        declarationDbId: declaration.declarationDbId,
      );

      if (cloudDeclaration.finalizedDeclarationDetails != null &&
          declarationDetails != null) {
        if (!cloudDeclaration.finalizedDeclarationDetails!.isEqualTo(
          declarationDetails!,
        )) {
          needsUpdate = true;
        }
      } else if (declarationDetails == null &&
          cloudDeclaration.finalizedDeclarationDetails != null) {
        needsUpdate = true;
      } else if (!declaration.isEqualTo(cloudDeclaration.baseDeclaration)) {
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
      }
    }
  }
}
