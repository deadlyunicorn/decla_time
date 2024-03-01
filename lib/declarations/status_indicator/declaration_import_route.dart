import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/status_indicator/declaration_status.dart";
import "package:decla_time/declarations/status_indicator/declaration_sync_controller.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
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
            context.mounted) {
          showErrorSnackbar(
              context: context,
              message:
                  "localized.this is taking too long.. check your internet connection and retry again by specifying again the date range.."); //TODO LOCALIZE
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
              ? "Importing: ${declarationSyncController.currentItemNumber} / ${declarationSyncController.total}"
              : "Loading.."
          : "No pending imports", //TODO Localize
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
                  declarationSyncController: declarationSyncController),
          ],
        ),
      ),
    );
  }
}

class ImportedDeclarations extends StatelessWidget {
  const ImportedDeclarations({
    super.key,
    required this.declarationSyncController,
    required this.localized,
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
            final String label = importedDeclaration.imported
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
                                  : "${declaration.arrivalDateString} - ${declaration.departureDateString}",
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "${declaration.cancellationAmount != null ? declaration.cancellationAmount!.toStringAsFixed(2) : declaration.payout.toStringAsFixed(2)}EUR - ${declaration.bookingPlatform.name.capitalized}",
                            ),
                          ),
                          FittedBox(
                            child: Text("declarationStatusTranslated"),
                          )
                        ],
                      )
                    : Text("Import error"),
                trailing: Tooltip(
                  message: label,
                  child: importedDeclaration.imported
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
    super.key,
    required this.declarationSyncController,
  });

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
              children: [
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
                  child: Text("declarationStatusTranslated"),
                )
              ],
            ),
          ),
        );
      },
      itemCount: declarationSyncController.declarationsToBeImported.length,
    );
  }
}
