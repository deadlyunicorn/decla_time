import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/column_with_spacings.dart';
import 'package:decla_time/declarations/database/user/user.dart';
import 'package:decla_time/users/drawer/users/properties/synchronize_drawer_button.dart';
import 'package:decla_time/users/drawer/users/user_drawer_tile.dart';
import 'package:decla_time/users/drawer/users/properties/user_properties_loader.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersList extends StatelessWidget {
  const UsersList({
    super.key,
    required this.localized,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final users = context
        .select<UsersController, List<User>>((controller) => controller.users);

    if (users.isEmpty) {
      return Column(
        children: [
          Text(
            localized.noUsersFound.capitalized,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      );
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ColumnWithSpacings(
              spacing: 8,
              children: [
                UserDrawerTile(
                  currentUser: users[index].username,
                ),
                UserPropertiesLoader(
                  currentUser: users[index].username,
                  localized: localized,
                ),
                SynchronizeDrawerButton(
                  currentUser: users[index].username,
                  localized: localized,
                )
              ],
            );
          });
    }
  }
}
