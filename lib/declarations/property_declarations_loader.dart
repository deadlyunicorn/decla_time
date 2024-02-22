import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/declarations/synchronize_declarations/declaration_sync_range_picker_dialog.dart';
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
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localized.noDeclarationsFound.capitalized),
              TextButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => DeclarationSyncRangePickerDialog(localized: localized),
                  );
                },
                child: Text(localized.syncDeclarations.capitalized),
              )
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
