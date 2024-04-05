import "dart:async";

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
import "package:decla_time/declarations/utility/network_requests/finalize_temporary_declaration.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_by_dbid.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
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

                await deleteTemporaryDeclaration(
                  removeFromDatabase:
                      isarHelper.declarationActions.removeFromDatabase,
                  headers: context.read<UsersController>().loggedUser.headers!,
                );

                if (context.mounted) {
                  Navigator.of(context).popUntil(
                    (Route<void> route) => route.isFirst,
                  );
                  ScaffoldMessenger.of(context).clearSnackBars();
                }
              } on NotLoggedInException {
                if (context.mounted) {
                  await loginUser(
                    credentials: context
                        .read<UsersController>()
                        .loggedUser
                        .userCredentials!,
                  ).then(
                    (DeclarationsPageHeaders newHeaders) async {
                      if (context.mounted) {
                        await deleteTemporaryDeclaration(
                          removeFromDatabase:
                              isarHelper.declarationActions.removeFromDatabase,
                          headers: newHeaders,
                        );
                      }
                    },
                  );
                }
              }
            },
            icon: Icon(
              Icons.dangerous,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        Tooltip(
          message: localized.finalizeDeclaration.capitalized,
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
                    builder: (BuildContext dialogContext) => CustomAlertDialog(
                      confirmButtonAction: () async {
                        try {
                          navigatorLoginIfNeeded(
                            context: dialogContext,
                            localized: localized,
                          );
                          showNormalSnackbar(
                            duration: const Duration(minutes: 1),
                            context: dialogContext,
                            message: "${localized.finalizing.capitalized}...",
                          );
                          try {
                            await finalizeTemporaryDeclarationByDeclarationDbId(
                              declaration: declaration,
                              headers: dialogContext
                                  .read<UsersController>()
                                  .loggedUser
                                  .headers!,
                              propertyId: declaration.propertyId,
                              declarationDbId: declaration.declarationDbId,
                            );
                          } on SuccessfullyFinalizedDeclarationException {
                            if (context.mounted) {
                              showNormalSnackbar(
                                context: context,
                                message:
                                    localized.finalizedSuccessfully.capitalized,
                              );
                            }
                          }

                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }
                          if (context.mounted) {
                            await resyncDeclaration(
                              context: context,
                              detailedDeclaration: DetailedDeclaration(
                                baseDeclaration: declaration,
                                finalizedDeclarationDetails:
                                    finalizedDeclarationDetails,
                              ),
                              localized: localized,
                            );
                          }
                        } on NotLoggedInException {
                          if (dialogContext.mounted) {
                            showErrorSnackbar(
                              context: dialogContext,
                              message: localized.somethingWentWrong.capitalized,
                            );
                          }
                        } on DeclarationWasUpdatedException {
                          //? Will show inside resync();
                        }
                      },
                      title: localized.finalizeDeclaration.capitalized,
                      localized: localized,
                      child: Text(
                        localized.finalizeDisclaimer,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              } on DeclarationWasUpdatedException {
                unawaited(
                  Future<void>.delayed(const Duration(seconds: 2)).then(
                    (_) {
                      if (context.mounted) {
                        showErrorSnackbar(
                          context: context,
                          message: localized.cancellingFinalization.capitalized,
                        );
                      }
                    },
                  ),
                );
              }
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

  Future<void> deleteTemporaryDeclaration({
    required Future<void> Function(int declarationDbId) removeFromDatabase,
    required DeclarationsPageHeaders headers,
  }) async {
    await deleteTemporaryDeclarationByDeclarationDbId(
      headers: headers,
      propertyId: declaration.propertyId,
      declarationDbId: declaration.declarationDbId,
    );
    await removeFromDatabase(declaration.declarationDbId);
  }
}
