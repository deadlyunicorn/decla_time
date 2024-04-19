import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ShowAverageNightRateButton extends StatelessWidget {
  const ShowAverageNightRateButton({
    required this.showAverageNightRate,
    required this.setShowAverageNightRate,
    required this.localized,
    super.key,
  });

  final bool showAverageNightRate;
  final Function(bool?) setShowAverageNightRate;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(localized.nightRateAverage.capitalized),
        Checkbox(
          value: showAverageNightRate,
          onChanged: setShowAverageNightRate,
        ),
      ],
    );
  }
}
