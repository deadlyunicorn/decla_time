import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/declarations/status_indicator/declaration_sync_controller.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class DeclarationImportRoute extends StatelessWidget {
  const DeclarationImportRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DeclarationSyncController declarationSyncController =
        context.watch<DeclarationSyncController>();

    return RouteOutline(
      title: "Importing",
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final SearchPageDeclaration currentDeclaration =
              declarationSyncController.currentDeclarations[index];
          return ListTile(
            title: Text(
              currentDeclaration.status.name,
            ),
            //TODO display currentItem/Total
            //TODO display the status of the declarations found so far.
            //TODO Display a ProgressIndicator if still importing.
          );
        },
        itemCount: declarationSyncController.currentDeclarations.length,
      ),
    );
  }
}
