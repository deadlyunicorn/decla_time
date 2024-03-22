import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/declarations/functions/resync_declaration.dart";
import "package:decla_time/declarations/utility/network_requests/get_declaration_by_dbid.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ResyncDeclarationButton extends StatelessWidget {
  const ResyncDeclarationButton({
    required this.localized,
    required this.declaration,
    required this.finalizedDeclarationDetails,
    super.key,
  });

  final AppLocalizations localized;
  final Declaration declaration;
  final FinalizedDeclarationDetails? finalizedDeclarationDetails;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: localized.sync.capitalized,
      child: IconButton(
        onPressed: () async {
          try {
            await resyncDeclaration(
              context: context,
              detailedDeclaration: DetailedDeclaration(
                baseDeclaration: declaration,
                finalizedDeclarationDetails: finalizedDeclarationDetails,
              ),
              localized: localized,
            );
          } on DeclarationWasUpdatedException {
            ///? Intended behaviour here.
          }
        },
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}
