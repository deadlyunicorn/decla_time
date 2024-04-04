import "package:decla_time/declarations/status_indicator_declare/declaration_submit_controller.dart";
import "package:decla_time/declarations/status_indicator_declare/submitting_route/declaration_uploading_route.dart";
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

  @override
  Widget build(BuildContext context) {
    final DeclarationSubmitController declarationSubmitController =
        context.watch<DeclarationSubmitController>();
    final bool isSubmitting = declarationSubmitController.isSubmitting;

    return (isSubmitting ||
            declarationSubmitController.reservationsSubmitted.isNotEmpty)
        ? CalculateIndicatorPosition(
            child: TextButton(
              style: TextButton.styleFrom().copyWith(
                shape: const MaterialStatePropertyAll<OutlinedBorder>(
                  CircleBorder(),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        DeclarationUploadingRoute(localized: widget.localized),
                  ),
                );
              },
              child: isSubmitting
                  ? const UploadAnimation()
                  : Stack(
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
                                  declarationSubmitController
                                      .reservationsSubmitted.length
                                      .toString(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.cloud_done_rounded),
                      ],
                    ),
            ),
          )
        : const SizedBox.shrink();
  }
}
