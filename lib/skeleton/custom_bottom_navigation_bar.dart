import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/skeleton/selected_page_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    required this.localized,
    super.key,
  });
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final SelectedPageController selectedPageProvider =
        context.watch<SelectedPageController>();

    return BottomNavigationBar(
      onTap: selectedPageProvider.setSelectedPageByIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.hotel),
          label: localized.reservations.capitalized,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.book),
          label: localized.declarations.capitalized,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.analytics),
          label: localized.analytics.capitalized,
        ),
      ],
      currentIndex: selectedPageProvider.selectedPageIndex,
    );
  }
}
