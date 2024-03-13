import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/status_indicator/declaration_status.dart";
import "package:decla_time/declarations/status_indicator/declarations_import_route/declaration_import_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ImportedDeclarations extends StatelessWidget {
  const ImportedDeclarations({
    required this.importedDeclarations,
    required this.localized,
    super.key,
  });

  final List<DeclarationImportStatus> importedDeclarations;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return ImportListViewOutline(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final Declaration importedDeclaration =
              importedDeclarations[index].declaration;
          final bool imported = importedDeclarations[index].imported;

          final bool didFail = importedDeclaration.declarationDbId == 1;
          final String label = didFail
              ? localized.failed.capitalized
              : imported
                  ? localized.added.capitalized
                  : localized.entryAlreadyExists.capitalized;

          return ImportListTileOutline(
            child: ListTile(
              title: didFail
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(localized.importFailed.capitalized),
                    )
                  : ImportedDeclarationDetails(
                      importedDeclaration: importedDeclaration,
                      localized: localized,
                    ),
              trailing: Tooltip(
                message: label,
                child: didFail
                    ? Icon(
                        Icons.error,
                        color: Theme.of(context).colorScheme.error,
                        semanticLabel: label,
                      )
                    : imported
                        ? Icon(
                            Icons.add_circle_outline,
                            semanticLabel: label,
                          )
                        : Icon(
                            semanticLabel: label,
                            Icons.phonelink_sharp,
                          ),
              ),
            ),
          );
        },
        itemCount: importedDeclarations.length,
      ),
    );
  }
}

class ImportedDeclarationDetails extends StatelessWidget {
  const ImportedDeclarationDetails({
    required this.importedDeclaration,
    required this.localized,
    super.key,
  });

  final Declaration importedDeclaration;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    bool isBigScreen = MediaQuery.sizeOf(context).width > kMaxWidthSmall;
    return Column(
      children: <Widget>[
        FittedBox(
          child: Text(
            importedDeclaration.cancellationDate != null
                // ignore: lines_longer_than_80_chars
                ? "${localized.cancelled.capitalized}: ${importedDeclaration.cancellationDateString}"
                // ignore: lines_longer_than_80_chars
                : "${importedDeclaration.arrivalDateString} - ${importedDeclaration.departureDateString}",
          ),
        ),
        Flex(
          direction: isBigScreen ? Axis.horizontal : Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
              child: Text(
                // ignore: lines_longer_than_80_chars
                "${importedDeclaration.cancellationAmount != null ? importedDeclaration.cancellationAmount!.toStringAsFixed(2) : importedDeclaration.payout.toStringAsFixed(2)} EUR - ${importedDeclaration.bookingPlatform.name.capitalized}",
              ),
            ),
            if (isBigScreen) const Text(" - "),
            FittedBox(
              child: Text(
                Declaration.getLocalizedDeclarationStatus(
                  localized: localized,
                  declarationStatus: importedDeclaration.declarationStatus,
                ).capitalized,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
