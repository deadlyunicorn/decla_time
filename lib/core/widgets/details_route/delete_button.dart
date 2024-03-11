import "package:decla_time/core/widgets/custom_alert_dialog.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    required this.size,
    required this.deleteFunction,
    required this.localized,
    required this.tooltipMessage,
    required this.dialogHeadline,
    required this.dialogBody,
    super.key,
  });

  final double size;
  final AppLocalizations localized;
  final Future<void> Function() deleteFunction;
  final String tooltipMessage;
  final String dialogHeadline;
  final String dialogBody;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage,
      child: SizedBox(
        height: size,
        width: size,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomAlertDialog(
                localized: localized,
                confirmButtonAction: () async {
                  await deleteFunction();
                  if (context.mounted) {
                    Navigator.popUntil(context, (Route<void> route) {
                      return route.isFirst;
                    });
                  }
                },
                title: dialogHeadline,
                child: Text(
                  dialogBody,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          child: Icon(
            Icons.delete_forever_rounded,
            size: 24,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
