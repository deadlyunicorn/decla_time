import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/details_route/details/finalized_declaration_details_section.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/details_route/main_container.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DeclarationDetailsContainer extends StatelessWidget {
  const DeclarationDetailsContainer({
    required this.declaration,
    required this.declarationDetails,
    required this.localized,
    super.key,
  });

  final Declaration declaration;
  final FinalizedDeclarationDetails? declarationDetails;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MainContainer(localized: localized, declaration: declaration),
        if (declarationDetails != null)
          FinalizedDeclarationDetailsSection(
            declarationDetails: declarationDetails!,
            localized: localized,
          ),
      ],
    );
  }
}
