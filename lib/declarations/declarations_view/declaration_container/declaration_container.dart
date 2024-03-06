import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/declaration_details_route.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/declaration_grid_item_container_items.dart";
import "package:decla_time/reservations/presentation/decleration_status_dot.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:intl/intl.dart";

class DeclarationContainer extends StatelessWidget {
  const DeclarationContainer({
    required this.declaration,
    required this.localized,
    super.key,
  });

  final Declaration declaration;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => DeclarationDetailsRoute(
                    localized: localized, declaration: declaration),
              ),
            );
          },
          child: DeclarationGridItemContainerItems(
            localized: localized,
            declaration: declaration,
          ),
        ),
        Positioned(
          //TODO - The tooltip won't work as it is outside the Stack.
          //TODO - Make some circle background for it
          bottom: -24,
          right: -4,
          child: DeclarationStatusDot(
            size: 24,
            localized: localized,
            declarationStatus: declaration.declarationStatus,
          ),
        ),
        Positioned(
          top: -16,
          left: 0,
          child: Text(
            DateFormat("dd").format(declaration.departureDate),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  fontSize: 16,
                ),
          ),
        ),
      ],
    );
  }
}
