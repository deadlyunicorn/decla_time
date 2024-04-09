import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DaysFilledPerMonthChart extends StatelessWidget {
  const DaysFilledPerMonthChart({
    super.key,
    required this.localized,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Text(localized.howToGetTheFiles);
  }
}
