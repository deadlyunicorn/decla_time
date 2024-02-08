import 'package:decla_time/core/enums/selected_page.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/reservations_action_button_menu/reservation_addition_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.selectedPage,
    required this.localized,
  });

  final SelectedPage selectedPage;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    switch (selectedPage) {
      case SelectedPage.reservations:
      case SelectedPage.declarations:
        return AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surface,
          ),
          height: 48,
          width: 48,
          duration: const Duration(milliseconds: 50),
          child: FloatingActionButton(
            onPressed: () {
              if (selectedPage == SelectedPage.reservations) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ReservationAdditionRoute(
                        localized: localized,
                      );
                    },
                  ),
                );
              } else {
                throw UnimplementedError();
                //Create a new declaration to the external .gov
              }
            },
            tooltip: selectedPage == SelectedPage.reservations
                ? localized.addEntries.capitalized
                : localized.newDeclaration.capitalized,
            child: const Icon(Icons.add),
          ),
        );

      case SelectedPage.analytics:
        return AnimatedContainer(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.surface,
          ),
          height: 16,
          width: 16,
          duration: const Duration(milliseconds: 50),
          child: const SizedBox.shrink(),
        );
    }
  }
}
