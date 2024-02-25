import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/users/drawer/users/properties/properties_list.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class UserPropertiesLoader extends StatelessWidget {
  const UserPropertiesLoader({
    required this.currentUser,
    required this.localized,
    super.key,
  });

  final String currentUser; //? users[i] of the previous ListBuilder
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<UserProperty>>(
      future: context
          .watch<IsarHelper>()
          .userActions
          .readProperties(username: currentUser),
      builder:
          (BuildContext context, AsyncSnapshot<Set<UserProperty>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final Set<UserProperty> properties = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: PropertiesList(properties: properties.toList()),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 64,
              height: 1,
              child: LinearProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
