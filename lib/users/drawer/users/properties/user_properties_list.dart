import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:decla_time/users/drawer/users/properties/properties_list.dart';
import 'package:decla_time/users/drawer/users/properties/synchronize_drawer_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class UserPropertiesLoader extends StatelessWidget {
  const UserPropertiesLoader({
    super.key,
    required this.currentUser,
    required this.localized,
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
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final properties = snapshot.data!;

          return Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: Column(
                children: [
                  PropertiesList(properties: properties.toList()),
                  SynchronizeDrawerButton(
                      currentUser: currentUser, localized: localized)
                ],
              ));
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
