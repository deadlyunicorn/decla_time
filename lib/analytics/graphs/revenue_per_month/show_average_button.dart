import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ShowAverageButton extends StatelessWidget {
  const ShowAverageButton({
    required this.showAverage,
    required this.setShowAverage,
    required this.localized,
    super.key,
  });

  final bool showAverage;
  final Function(bool?) setShowAverage;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(localized.average.capitalized),
        Checkbox(
          value: showAverage,
          onChanged: setShowAverage,
        ),
      ],
    );
  }
}
