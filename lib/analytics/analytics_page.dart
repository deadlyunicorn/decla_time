import "package:decla_time/analytics/app_settings.dart";
import "package:decla_time/analytics/graphs/analytics_graphs.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: ColumnWithSpacings(
          spacing: 64,
          children: <Widget>[
            Text(
              localized.analytics.capitalized,
              style: Theme.of(context).textTheme.headlineLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            AnalyticsGraphs(localized: localized),
            AppSettings(localized: localized),
          ],
        ),
      ),
    );
  }
}
