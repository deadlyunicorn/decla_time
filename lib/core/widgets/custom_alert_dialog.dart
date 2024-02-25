import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    required this.confirmButtonAction,
    required this.title,
    required this.child,
    required this.localized,
    super.key,
  });

  final void Function() confirmButtonAction;
  final String title;
  final Widget child;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight > kMaxWidthSmall ? screenHeight : null,
        child: AlertDialog(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(title),
          ),
          content: SizedBox(
            width: kMaxWidthSmall,
            child: child,
          ),
          actions: <Widget>[
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(localized.cancel.capitalized),
                  ),
                  TextButton(
                    onPressed: () {
                      confirmButtonAction();
                    },
                    child: Text(localized.confirm.capitalized),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
