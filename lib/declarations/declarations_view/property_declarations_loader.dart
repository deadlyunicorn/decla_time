import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/generic_calendar_grid_view/generic_calendar_grid_view.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/declarations/declarations_view/declaration_actions.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/declaration_container.dart";
import "package:decla_time/declarations/declarations_view/temporary_declarations_section.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class PropertyDeclarationsLoader extends StatelessWidget {
  const PropertyDeclarationsLoader({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final UserProperty? selectedProperty =
        context.select<UsersController, UserProperty?>(
      (UsersController controller) => controller.selectedProperty,
    );

    return FutureBuilder<List<Declaration>>(
      future: context
          .watch<IsarHelper>()
          .declarationActions
          .getAllDeclarationsByPropertyIdSorted(
            propertyId: selectedProperty?.propertyId ?? "",
          ),
      builder: (_, AsyncSnapshot<List<Declaration>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<Declaration> declarations =
              snapshot.data ?? <Declaration>[];

          final List<Declaration> temporaryDeclarations = declarations
              .where(
                (Declaration declaration) =>
                    declaration.declarationStatus ==
                    DeclarationStatus.temporary,
              )
              .toList();

          return ColumnWithSpacings(
            spacing: 16,
            children: <Widget>[
              DeclarationActions(
                localized: localized,
                selectedProperty: selectedProperty,
                totalDeclarations: declarations.length,
              ),
              if (temporaryDeclarations.isNotEmpty)
                TemporaryDeclarationsSection(
                  temporaryDeclarations: temporaryDeclarations,
                  localized: localized,
                ),
              GenericCalendarGridView<Declaration>(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120,
                ),
                items: declarations,
                localized: localized,
                child: (Declaration declaration) => DeclarationContainer(
                  localized: localized,
                  declaration: declaration,
                  positionedChildren: <Widget>[
                    Positioned(
                      top: -16,
                      left: 0,
                      child: Text(
                        DateFormat("dd").format(declaration.departureDate),
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.7),
                                  fontSize: 16,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
