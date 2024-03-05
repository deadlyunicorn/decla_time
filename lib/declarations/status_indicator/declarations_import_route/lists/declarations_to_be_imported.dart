import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/status_indicator/declarations_import_route/declaration_import_route.dart";
import "package:decla_time/declarations/status_indicator/declarations_import_route/declaration_sync_controller.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

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
    return ImportListViewOutline(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final SearchPageDeclaration declarationToBeImported =
              declarationSyncController.declarationsToBeImported[index];

          return ImportListTileOutline(
            child: ListTile(
              trailing: const CircularProgressIndicator(),
              title: DeclarationToBeImportedDetails(
                declarationToBeImported: declarationToBeImported,
                localized: localized,
              ),
            ),
          );
        },
        itemCount: declarationSyncController.declarationsToBeImported.length,
      ),
    );
  }
}

class DeclarationToBeImportedDetails extends StatelessWidget {
  const DeclarationToBeImportedDetails({
    required this.declarationToBeImported,
    required this.localized,
    super.key,
  });

  final SearchPageDeclaration declarationToBeImported;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    bool isBigScreen = MediaQuery.sizeOf(context).width > kMaxWidthSmall;

    return Column(
      children: <Widget>[
        FittedBox(
          child: Text(
            // ignore: lines_longer_than_80_chars
            "${declarationToBeImported.arrivalDateString} - ${declarationToBeImported.departureDateString}",
          ),
        ),
        Flex(
          direction: isBigScreen ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
              child: Text(
                "${declarationToBeImported.payout} EUR", 
              ),
            ),
            if (isBigScreen) const Text(" - "),
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
      ],
    );
  }
}
