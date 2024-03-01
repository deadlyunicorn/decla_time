import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/status_indicator/declaration_status.dart";
import "package:decla_time/declarations/status_indicator/declaration_sync_controller.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
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
      Future<void>.delayed(const Duration(minutes: 2, seconds: 30)).then((_) {
        if (currentDeclaration == declarationSyncController.currentItemNumber &&
            context.mounted &&
            declarationSyncController.isImporting) {
          showErrorSnackbar(
            context: context,
            message: localized.importTakingTooLong.capitalized,
          );
        }
      });
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
        //TODO Scrollbar doesnt work (like scrolling with the mouse wheel)
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ImportedDeclarations(
                declarationSyncController: declarationSyncController,
                localized: localized),
            if (declarationSyncController.declarationsToBeImported.isNotEmpty)
              DeclarationsToBeImported(
                  localized: localized,
                  declarationSyncController: declarationSyncController),
          ],
        ),
      ),
    );
  }
}

class ImportedDeclarations extends StatelessWidget {
  const ImportedDeclarations({
    required this.declarationSyncController,
    required this.localized,
    super.key,
  });

  final DeclarationSyncController declarationSyncController;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final DeclarationImportStatus importedDeclaration =
            declarationSyncController.importedDeclarations[index];

        return FutureBuilder<Declaration?>(
          future: context
              .watch<IsarHelper>()
              .declarationActions
              .getDeclarationEntryByIsarId(
                importedDeclaration.localDeclarationId,
              ),
          builder: (
            BuildContext context,
            AsyncSnapshot<Declaration?> snapshot,
          ) {
            final String label = importedDeclaration.localDeclarationId == 1
                ? localized.failed.capitalized
                : importedDeclaration.imported
                    ? localized.added.capitalized
                    : localized.entryAlreadyExists.capitalized;
            final Declaration? declaration = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: declaration != null
                    ? Column(
                        children: <Widget>[
                          FittedBox(
                            child: Text(
                              declaration.cancellationDate != null
                                  ? "${declaration.cancellationDateString}"
                                  // ignore: lines_longer_than_80_chars
                                  : "${declaration.arrivalDateString} - ${declaration.departureDateString}",
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              // ignore: lines_longer_than_80_chars
                              "${declaration.cancellationAmount != null ? declaration.cancellationAmount!.toStringAsFixed(2) : declaration.payout.toStringAsFixed(2)}EUR - ${declaration.bookingPlatform.name.capitalized}",
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              Declaration.getLocalizedDeclarationStatus(
                                localized: localized,
                                declarationStatus:
                                    declaration.declarationStatus,
                              ).capitalized,
                            ),
                          ),
                        ],
                      )
                    : FittedBox(
                        child: Text(localized.importFailed.capitalized),
                      ),
                trailing: Tooltip(
                  message: label,
                  child: importedDeclaration.localDeclarationId == 1
                      ? Icon(
                          Icons.error,
                          color: Theme.of(context).colorScheme.error,
                          semanticLabel: label,
                        )
                      : importedDeclaration.imported
                          ? Icon(
                              Icons.add_circle_outline,
                              semanticLabel: label,
                            )
                          : Icon(
                              semanticLabel: label,
                              Icons.phonelink_sharp,
                            ),
                ),

                //TODO display currentItem/Total
                //TODO display the status of the declarations found so far.
                //TODO Display a ProgressIndicator if still importing.
              ),
            );
          },
        );
      },
      itemCount: declarationSyncController.importedDeclarations.length,
    );
  }
}

class DeclarationsToBeImported extends StatelessWidget {
  const DeclarationsToBeImported({
    required this.declarationSyncController,
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;
  final DeclarationSyncController declarationSyncController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final SearchPageDeclaration declarationToBeImported =
            declarationSyncController.declarationsToBeImported[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            trailing: const CircularProgressIndicator(),
            title: Column(
              children: <Widget>[
                FittedBox(
                  child: Text(
                    "${declarationToBeImported.arrivalDateString} - ${declarationToBeImported.departureDateString}",
                  ),
                ),
                FittedBox(
                  child: Text(
                    "${declarationToBeImported.payout} EUR", // TODO Check if cancellation date is applicable - check how this is extracted.
                  ),
                ),
                FittedBox(
                  child: Text(
                    Declaration.getLocalizedDeclarationStatus(
                      localized: localized,
                      declarationStatus: declarationToBeImported.status,
                    ).capitalized,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: declarationSyncController.declarationsToBeImported.length,
    );
  }
}
