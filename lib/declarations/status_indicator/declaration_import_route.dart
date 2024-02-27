import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
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

    final List<SearchPageDeclaration> declarationsToBeImported =
        declarationSyncController.declarationsToBeImported;

    final importedDeclarations = declarationSyncController.importedDeclarations;

    return RouteOutline(
      title: "Importing",
      child: Column(
        children: <Widget>[
          if (declarationSyncController.declarationsToBeImported.length > 0)
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => Text(
                declarationSyncController.declarationsToBeImported[index].status
                    .toString(),
              ),
              itemCount:
                  declarationSyncController.declarationsToBeImported.length,
            ),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final DeclarationImportStatus currentDeclaration =
                  declarationSyncController.importedDeclarations[index];

              return FutureBuilder<Declaration?>(
                  future: context
                      .watch<IsarHelper>()
                      .declarationActions
                      .getDeclarationEntryByIsarId(
                        currentDeclaration.localDeclarationId,
                      ),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<Declaration?> snapshot,
                  ) {
                    final String label = currentDeclaration.imported
                        ? localized.added.capitalized
                        : localized.entryAlreadyExists.capitalized;
                    return ListTile(
                      title: Text(
                        snapshot.data?.declarationStatus.name ?? "...",
                      ),
                      trailing: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: <Widget>[
                          Tooltip(
                            message: label,
                            child: currentDeclaration.imported
                                ? Icon(
                                    Icons.add_circle_outline,
                                    semanticLabel: label,
                                  )
                                : Icon(
                                    semanticLabel: label,
                                    Icons.phonelink_sharp,
                                  ),
                          ),
                        ],
                      ),

                      //TODO display currentItem/Total
                      //TODO display the status of the declarations found so far.
                      //TODO Display a ProgressIndicator if still importing.
                    );
                  });
            },
            itemCount: declarationSyncController.importedDeclarations.length,
          ),
        ],
      ),
    );
  }
}
