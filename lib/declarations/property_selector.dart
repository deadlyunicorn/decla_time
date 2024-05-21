import "dart:math";

import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/declarations/declarations_view/property_declarations_loader.dart";
import "package:decla_time/declarations/properties/available_user_properties.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class PropertySelector extends StatelessWidget {
  final AppLocalizations localized;

  const PropertySelector({
    required this.localized,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String selectedUser = context.select<UsersController, String>(
      (UsersController controller) => controller.selectedUser,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: ColumnWithSpacings(
        spacing: 32,
        children: <Widget>[
          Headline(
            selectedUser: selectedUser,
            localized: localized,
          ),
          FutureBuilder<Set<UserProperty>>(
            future: context
                .watch<IsarHelper>()
                .userActions
                .readProperties(username: selectedUser),
            builder: (
              BuildContext context,
              AsyncSnapshot<Set<UserProperty>> snapshot,
            ) {
              return AvailableUserProperties(
                localized: localized,
                currentUser: selectedUser,
                userProperties: <UserProperty>[...?snapshot.data],
              );
            },
          ),
          //* In here declarations
          PropertyDeclarationsLoader(
            localized: localized,
          ),
        ],
      ),
    );
  }
}

class Headline extends StatelessWidget {
  const Headline({
    required this.localized,
    required this.selectedUser,
    super.key,
  });

  final AppLocalizations localized;
  final String selectedUser;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: max(
          min(MediaQuery.sizeOf(context).width, kMaxWidthLargest),
          256,
        ),
        child: Text(
          "${localized.viewingDeclarationsOf.capitalized}\n $selectedUser",
          style: Theme.of(context).textTheme.headlineMedium,
          //?Apparently this line of code causes a lot of rebuilds :)
          maxLines: 3,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
