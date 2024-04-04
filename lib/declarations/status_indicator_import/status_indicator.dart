import "package:decla_time/declarations/status_indicator_import/animations.dart";
import "package:decla_time/declarations/status_indicator_import/calculate_indicator_position.dart";
import "package:decla_time/declarations/status_indicator_import/declaration_status.dart";
import "package:decla_time/declarations/status_indicator_import/declarations_import_route/declaration_import_controller.dart";
import "package:decla_time/declarations/status_indicator_import/declarations_import_route/declaration_import_route.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class StatusIndicatorImport extends StatefulWidget {
  const StatusIndicatorImport({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;
  static const double buttonSize = 48;

  @override
  State<StatusIndicatorImport> createState() => _StatusIndicatorImportState();
}

class _StatusIndicatorImportState extends State<StatusIndicatorImport> {
  List<SearchPageDeclaration> importedDeclarations = <SearchPageDeclaration>[];
  List<SearchPageDeclaration> currentDeclarations = <SearchPageDeclaration>[];

  @override
  Widget build(BuildContext context) {
    final bool isImporting = context.select<DeclarationImportController, bool>(
      (DeclarationImportController controller) => controller.isImporting,
    );

    final List<DeclarationImportStatus> currentDeclarations = context
        .select<DeclarationImportController, List<DeclarationImportStatus>>(
      (DeclarationImportController controller) =>
          controller.importedDeclarations,
    );

    return (isImporting || currentDeclarations.isNotEmpty)
        ? CalculateIndicatorPosition(
            child: TextButton(
              // ignore: lines_longer_than_80_chars
              //TODO - pressing "Back key' on Android doesn't discard the imported things
              style: TextButton.styleFrom().copyWith(
                shape: const MaterialStatePropertyAll<OutlinedBorder>(
                  CircleBorder(),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => DeclarationImportRoute(
                      localized: widget.localized,
                    ),
                  ),
                );
              },
              child: isImporting
                  ? const SyncingAnimatedIcon()
                  : Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Positioned(
                          bottom: -4,
                          right: -16,
                          child: SizedBox(
                            width: StatusIndicatorImport.buttonSize,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: StatusIndicatorImport.buttonSize / 2,
                                child: Text(
                                  "${currentDeclarations.length}",
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.done),
                      ],
                    ),
            ),
          )
        : const SizedBox.shrink();
  }
}
