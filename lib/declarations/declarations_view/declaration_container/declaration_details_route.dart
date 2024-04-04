import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/details_route/declaration_details_container.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class DeclarationDetailsRoute extends StatelessWidget {
  const DeclarationDetailsRoute({
    required this.localized,
    required this.declaration,
    super.key,
  });

  final AppLocalizations localized;
  final Declaration declaration;

  @override
  Widget build(BuildContext context) {
    return RouteOutline(
      title: localized.details.capitalized,
      child: FutureBuilder<FinalizedDeclarationDetails?>(
        future: context
            .watch<IsarHelper>()
            .declarationActions
            .getFinalizedDeclarationDetailsByDeclarationDbId(
              declaration.declarationDbId,
            ),
        builder: (
          BuildContext context,
          AsyncSnapshot<FinalizedDeclarationDetails?> snapshot,
        ) {
          final FinalizedDeclarationDetails? declarationDetails = snapshot.data;

          return SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              //!If  you remove this it will keep the scrollbar
              //!  on the details box
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: <Widget>[
                    DeclarationDetailsContainer(
                      declaration: declaration,
                      declarationDetails: declarationDetails,
                      localized: localized,
                    ),
                    const SizedBox.square(dimension: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
