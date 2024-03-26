import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/generic_calendar_grid_view/year/month/item/item_material_outline.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/declaration_container.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:intl/intl.dart";

class TemporaryDeclarationsSection extends StatelessWidget {
  const TemporaryDeclarationsSection({
    required this.temporaryDeclarations,
    required this.localized,
    super.key,
  });

  final List<Declaration> temporaryDeclarations;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ColumnWithSpacings(
          spacing: 32,
          children: <Widget>[
            Text(
              localized.temporaryDeclarations.capitalized,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            GridView.builder(
              itemCount: temporaryDeclarations.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 120,
                mainAxisSpacing: 32,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ItemMaterialOutline<Declaration>(
                  item: temporaryDeclarations[index],
                  localized: localized,
                  child: (Declaration declaration) => DeclarationContainer(
                    declaration: declaration,
                    localized: localized,
                    positionedChildren: <Widget>[
                      Positioned(
                        top: -24,
                        left: 0,
                        right: 0,
                        child: Text(
                          DateFormat("dd - MM - yy")
                              .format(declaration.departureDate),
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.7),
                                fontSize: 16,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
