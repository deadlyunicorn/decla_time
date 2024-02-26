import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/declarations/status_indicator/animations.dart";
import "package:decla_time/declarations/status_indicator/calculate_indicator_position.dart";
import "package:decla_time/declarations/status_indicator/declaration_import_route.dart";
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

    return (isImporting)
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
                    builder: (BuildContext context) => DeclarationImportRoute(),
                  ),
                );
                showErrorSnackbar(context: context, message: "hello");
              },
              child:
                  const AnimationTest2(), //AnimationTest2(animation: _animation), //TODO TO change.
            ),
          )
        : const SizedBox.shrink();
  }
}
