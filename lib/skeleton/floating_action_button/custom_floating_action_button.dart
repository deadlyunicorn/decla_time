import "package:decla_time/core/enums/selected_page.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/declarations_action_button_menu/declaration_submit_route.dart";
import "package:decla_time/reservations_action_button_menu/reservation_addition_route.dart";
import "package:decla_time/skeleton/selected_page_controller.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final SelectedPage selectedPage =
        context.watch<SelectedPageController>().selectedPage;

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
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return ReservationAdditionRoute(
                        localized: localized,
                      );
                    },
                  ),
                );
              } else if (selectedPage == SelectedPage.declarations) {
                final UserProperty? selectedProperty =
                    context.read<UsersController>().selectedProperty;
                if (selectedProperty != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return DeclarationSubmitRoute(
                          localized: localized,
                          selectedProperty: selectedProperty,
                        );
                      },
                    ),
                  );
                } else {
                  showErrorSnackbar(
                    context: context,
                    message: localized.noPropertySelected.capitalized,
                  );
                }
              } else {
                showErrorSnackbar(
                  context: context,
                  message: "Not implemented. Report to dev.",
                );
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
