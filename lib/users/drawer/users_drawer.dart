import 'package:decla_time/core/widgets/column_with_spacings.dart';
import 'package:decla_time/declarations/database/user/user.dart';
import 'package:decla_time/users/drawer/add_user_button.dart';
import 'package:decla_time/users/drawer/drawer_outline.dart';
import 'package:decla_time/users/drawer/users_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UsersDrawer extends StatelessWidget {
  const UsersDrawer({
    super.key,
    required this.localized,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final List<User> users = []; // context.watch<UsersController>().users;

    return DrawerOutline(
      child: ColumnWithSpacings(
        spacing: 16,
        children: [
          Text(
            "Users",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox.square(
            dimension: 16,
          ),
          UsersList(
            users: users,
            localized: localized,
          ),
          AddUserButton(
            localized: localized,
          ),
        ],
      ),
    );
  }
}
