import "package:decla_time/declarations/status_indicator_declare/declaration_submit_controller.dart";
import "package:decla_time/declarations/status_indicator_import/animations.dart";
import "package:decla_time/declarations/status_indicator_import/calculate_indicator_position.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class StatusIndicatorSubmit extends StatefulWidget {
  const StatusIndicatorSubmit({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;
  static const double buttonSize = 48;

  @override
  State<StatusIndicatorSubmit> createState() => _StatusIndicatorSubmitState();
}

class _StatusIndicatorSubmitState extends State<StatusIndicatorSubmit> {
  // List<SearchPageDeclaration> importedDeclarations = <SearchPageDeclaration>[];
  // List<SearchPageDeclaration> currentDeclarations = <SearchPageDeclaration>[];

  // final List<DeclarationImportStatus> currentDeclarations = context
  //     .select<DeclarationImportController, List<DeclarationImportStatus>>(
  //   (DeclarationImportController controller) => controller.importedDeclarations,
  // );

  @override
  Widget build(BuildContext context) {
    final bool isSubmitting = context.select<DeclarationSubmitController, bool>(
      (DeclarationSubmitController controller) => controller.isSubmitting,
    );

    return (!isSubmitting //|| currentDeclarations.isNotEmpty
        )
        ? CalculateIndicatorPosition(
            child: TextButton(
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
                    builder: (BuildContext context) => //TODO Add a delete button on temporary declarations ( on the declarations page. )
                        const DeclarationSubmittingRoute(),
                  ),
                );
              },
              child: !isSubmitting
                  ? const UploadAnimation()
                  : const Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Positioned(
                          top: -8,
                          right: -24,
                          child: SizedBox(
                            width: StatusIndicatorSubmit.buttonSize,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: StatusIndicatorSubmit.buttonSize / 2,
                                child: Text(
                                  "999"
                                  //TODO Later. "${currentDeclarations.length}",
                                ),
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.cloud_done_rounded),
                      ],
                    ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class DeclarationSubmittingRoute extends StatelessWidget {
  const DeclarationSubmittingRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text("ahiy");
  }
}