import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/declarations/database/user/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class UsersList extends StatelessWidget {
  const UsersList({
    super.key,
    required this.users,
    required this.localized,
  });

  final List<User> users;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
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
        itemCount: users.length,
        itemBuilder: (context, index) => Text(users[index].username),
      );
    }
  }
}
