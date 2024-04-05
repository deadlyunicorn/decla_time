import "dart:async";

import "package:decla_time/analytics/app_settings.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/settings.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class AppDisclaimer extends StatelessWidget {
  const AppDisclaimer({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.sizeOf(context).height < 400 ||
              MediaQuery.sizeOf(context).width < 360
          ? SingleChildScrollView(
              child: DisclaimerBody(localized: localized),
            )
          : DisclaimerBody(localized: localized),
    );
  }
}

class DisclaimerBody extends StatelessWidget {
  const DisclaimerBody({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: kMaxWidthMedium,
          child: ColumnWithSpacings(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                localized.disclaimer.capitalized,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                localized.appDisclaimer,
                textAlign: TextAlign.center,
              ),
              ToggleLocaleButton(localized: localized),
              TextButton(
                onPressed: () async {
                  unawaited(
                    context.read<SettingsController>().acceptDisclaimer(),
                  );
                },
                child: Text(localized.userUnderstands.capitalized),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
