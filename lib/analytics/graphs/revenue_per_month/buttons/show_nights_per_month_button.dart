import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ShowNightsPerMonthButton extends StatelessWidget {
  const ShowNightsPerMonthButton({
    required this.showNights,
    required this.setShowNights,
    required this.localized,
    super.key,
  });

  final bool showNights;
  final Function(bool?) setShowNights;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(localized.displayNightsPerMonth.capitalized),
        Checkbox(
          value: showNights,
          onChanged: setShowNights,
        ),
      ],
    );
  }
}
