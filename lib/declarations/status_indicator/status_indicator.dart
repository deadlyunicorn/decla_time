import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/declarations/status_indicator/animations.dart";
import "package:decla_time/declarations/status_indicator/calculate_indicator_position.dart";
import "package:decla_time/declarations/status_indicator/declaration_import_route.dart";
import "package:decla_time/declarations/status_indicator/declaration_status.dart";
import "package:decla_time/declarations/status_indicator/declaration_sync_controller.dart";
import "package:decla_time/declarations/utility/search_page_declaration.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class StatusIndicator extends StatefulWidget {
  const StatusIndicator({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;
  static const double buttonSize = 48;

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator> {
  List<SearchPageDeclaration> importedDeclarations = <SearchPageDeclaration>[];
  List<SearchPageDeclaration> currentDeclarations = <SearchPageDeclaration>[];

  @override
  Widget build(BuildContext context) {
    final bool isImporting = context.select<DeclarationSyncController, bool>(
      (DeclarationSyncController controller) => controller.isImporting,
    );

    final List<DeclarationImportStatus> currentDeclarations = context
        .select<DeclarationSyncController, List<DeclarationImportStatus>>(
      (DeclarationSyncController controller) =>
          controller.importedDeclarations,
    );

    return (isImporting || currentDeclarations.isNotEmpty)
        ? CalculateIndicatorPosition(
            child: TextButton(
              style: TextButton.styleFrom().copyWith(
                shape: const MaterialStatePropertyAll<OutlinedBorder>(
                  CircleBorder(),
                ),
              ),
              onPressed: () {
                //TODO remove snackabars.
                showErrorSnackbar(context: context, message: "hello");

                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => DeclarationImportRoute(
                      localized: widget.localized,
                    ),
                  ),
                );
                showErrorSnackbar(context: context, message: "hello");
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
                            width: StatusIndicator.buttonSize,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: StatusIndicator.buttonSize / 2,
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
