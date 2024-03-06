import "package:decla_time/analytics/analytics_page.dart";
import "package:decla_time/core/enums/selected_page.dart";
import "package:decla_time/declarations/declarations_page.dart";
import "package:decla_time/reservations/reservations_page.dart";
import "package:decla_time/skeleton/selected_page_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class SelectPageToDisplay extends StatelessWidget {
  const SelectPageToDisplay({
    required this.localized,
    required this.scrollController,
    super.key,
  });
  final AppLocalizations localized;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final SelectedPage selectedPage =
        context.watch<SelectedPageController>().selectedPage;

    switch (selectedPage) {
      case SelectedPage.reservations:
        return ReservationsPage(
          scrollController: scrollController,
          localized: localized,
        );
      case SelectedPage.declarations:
        return DeclarationsPage(
          scrollController: scrollController,
          localized: localized,
        );
      case SelectedPage.analytics:
        return AnalyticsPage(
          localized: localized,
        );
    }
  }
}
