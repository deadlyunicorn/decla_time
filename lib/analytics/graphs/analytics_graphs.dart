import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class AnalyticsGraphs extends StatelessWidget {
  const AnalyticsGraphs({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return ColumnWithSpacings(
      spacing: 16,
      children: <Widget>[
        
        Text(localized.howToGetTheFiles),
        Text(localized.howToGetTheFiles),
        Text(localized.howToGetTheFiles),
      ],
    );
  }
}
