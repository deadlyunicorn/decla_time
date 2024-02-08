import 'package:decla_time/core/enums/selected_page.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final void Function(int) setSelectedPage;
  final SelectedPage selectedPage;

  const CustomBottomNavigationBar({
    super.key,
    required this.setSelectedPage,
    required this.selectedPage,
    required this.localized,
  });
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: setSelectedPage,
      items: [
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
      currentIndex: convertSelectedPageToIndex(selectedPage),
    );
  }
}
