import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/declarations/components/declaration_actions.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';

class PropertyDeclarationsLoader extends StatelessWidget {
  const PropertyDeclarationsLoader({
    super.key,
    required this.localized,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final selectedPropertyId = context.select<UsersController, String>(
      (controller) => controller.selectedProperty,
    );

    return FutureBuilder(
      future: context
          .watch<IsarHelper>()
          .declarationActions
          .getAllDeclarationsFrom(propertyId: selectedPropertyId),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              DeclarationActions(
                  localized: localized, selectedPropertyId: selectedPropertyId),
              const SizedBox(
                  height: 450, child: Center(child: Text("Declarations Below")))
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
