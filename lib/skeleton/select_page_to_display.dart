import 'package:decla_time/analytics/analytics_page.dart';
import 'package:decla_time/core/enums/selected_page.dart';
import 'package:decla_time/declarations/declarations_page.dart';
import 'package:decla_time/reservations/reservations_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SelectPageToDisplay extends StatelessWidget {
  final SelectedPage selectedPage;

  const SelectPageToDisplay({
    super.key,
    required this.selectedPage,
    required this.localized,
  });
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    switch (selectedPage) {
      case SelectedPage.reservations:
        return ReservationsPage(
          localized: localized,
        );
      case SelectedPage.declarations:
        return DeclarationsPage(
          localized: localized,
        );
      case SelectedPage.analytics:
        return AnalyticsPage(
          localized: localized,
        );
    }
  }
}
