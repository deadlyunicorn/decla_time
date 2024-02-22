import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/widgets/column_with_spacings.dart';
import 'package:decla_time/declarations/properties/available_user_properties.dart';
import 'package:decla_time/declarations/property_declarations_loader.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PropertySelector extends StatelessWidget {
  final AppLocalizations localized;

  const PropertySelector({
    super.key,
    required this.localized,
  });

  @override
  Widget build(BuildContext context) {
    final selectedUser = context.select<UsersController, String>(
      (controller) => controller.selectedUser,
    );

    //TODO!!! display declarations even if the user is not logged in ( if they are synced. ?)

    //TODO After we sync the properties we need to SYNC the existing declarations

    //TODO When submitting declarations:
    //TODO + We have a 'queue' where we can add from our reservation list
    //TODO + We can press "SYNC NOW" to start syncing one by one. ( rate limit )

    //TODO Handle 302 - Log out etc.

    //TODO + After we submit our declaration we can read the response body or headers( location->url ) to check the declarationDbId.

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: ColumnWithSpacings(
        spacing: 32,
        children: [
          Text(
            "Viewing the  of selectedUser",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          FutureBuilder(
            future: context
                .watch<IsarHelper>()
                .userActions
                .readProperties(username: selectedUser),
            builder: (context, snapshot) {
              return AvailableUserProperties(
                localized: localized,
                currentUser: selectedUser,
                userProperties: [...?snapshot.data],
              );
            },
          ),
          PropertyDeclarationsLoader(
            localized: localized,
          ),
        ],
      ),
    );
  }
}
