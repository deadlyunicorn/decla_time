import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/declarations_view/declaration_actions.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class PropertyDeclarationsLoader extends StatelessWidget {
  const PropertyDeclarationsLoader({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final String selectedPropertyId = context.select<UsersController, String>(
      (UsersController controller) => controller.selectedProperty,
    );

    return FutureBuilder<List<Declaration>>(
      future: context
          .watch<IsarHelper>()
          .declarationActions
          .getAllDeclarationsFrom(propertyId: selectedPropertyId),
      builder: (_, AsyncSnapshot<List<Declaration>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<Declaration> declarations =
              snapshot.data ?? <Declaration>[];

          return Column(
            children: <Widget>[
              DeclarationActions(
                localized: localized,
                selectedPropertyId: selectedPropertyId,
                totalDeclarations: declarations.length,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: declarations.length,
                itemBuilder: (BuildContext context, int index) => Text(
                  declarations[index].declarationStatus.name,
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
