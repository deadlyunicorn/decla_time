import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/declarations/status_indicator_import/declaration_status.dart";
import "package:decla_time/declarations/status_indicator_import/declarations_import_route/declaration_sync_controller.dart";
import "package:decla_time/declarations/status_indicator_import/declarations_import_route/lists/declarations_to_be_imported.dart";
import "package:decla_time/declarations/status_indicator_import/declarations_import_route/lists/imported_declarations.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class DeclarationImportRoute extends StatelessWidget {
  const DeclarationImportRoute({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final DeclarationSyncController declarationSyncController =
        context.watch<DeclarationSyncController>();

    if (declarationSyncController.isImporting) {
      final int currentDeclaration =
          declarationSyncController.currentItemNumber;

      Future<void>.delayed(const Duration(minutes: 2, seconds: 30)).then(
        (_) {
          if (currentDeclaration ==
                  declarationSyncController.currentItemNumber &&
              context.mounted &&
              declarationSyncController.isImporting) {
            showErrorSnackbar(
              context: context,
              message: localized.importTakingTooLong.capitalized,
            );
          }
        },
      );
    }

    return RouteOutline(
      onExit: () {
        declarationSyncController
            .setImportedDeclarations(<DeclarationImportStatus>[]);
      },
      title: declarationSyncController.isImporting
          ? declarationSyncController.total > 0
              ? "${localized.importing.capitalized}: ${declarationSyncController.currentItemNumber} / ${declarationSyncController.total}"
              : "${localized.loading.capitalized}.."
          : localized.noPendingImports.capitalized,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox.square(
              dimension: 16,
            ),
            ImportedDeclarations(
              importedDeclarations:
                  declarationSyncController.importedDeclarations,
              localized: localized,
            ),
            if (declarationSyncController.declarationsToBeImported.isNotEmpty)
              DeclarationsToBeImported(
                localized: localized,
                declarationSyncController: declarationSyncController,
              ),
            const SizedBox.square(
              dimension: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class ImportListTileOutline extends StatelessWidget {
  const ImportListTileOutline({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withAlpha(96),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: child,
      ),
    );
  }
}

class ImportListViewOutline extends StatelessWidget {
  const ImportListViewOutline({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: kMaxWidthSmall,
        child: child,
      ),
    );
  }
}
