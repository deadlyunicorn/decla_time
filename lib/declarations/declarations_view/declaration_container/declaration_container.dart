import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/declaration_details_route.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/declaration_grid_item_container_items.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DeclarationContainer extends StatelessWidget {
  const DeclarationContainer({
    required this.declaration,
    required this.localized,
    required this.positionedChildren,
    super.key,
  });

  final Declaration declaration;
  final AppLocalizations localized;
  final List<Widget> positionedChildren;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => DeclarationDetailsRoute(
                  localized: localized,
                  declaration: declaration,
                ),
              ),
            );
          },
          child: DeclarationGridItemContainerItems(
            localized: localized,
            declaration: declaration,
          ),
        ),
        ...positionedChildren,
      ],
    );
  }
}
