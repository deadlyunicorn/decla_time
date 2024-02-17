import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/declarations/database/user/user.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    //TODO IN PROGRESS
    final selectedUser = context.watch<UsersController>().selectedUser;
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
            final bool isCurrentlySelectedUser =
                selectedUser == users[index].username;

            return Column(
              children: [
                ListTile(
                  title: RichText(
                    text: TextSpan(
                        text: users[index].username,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(),
                        children: isCurrentlySelectedUser
                            ? [
                                TextSpan(
                                    text: "logged in", //TODO change this.
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          fontSize: 12,
                                          color: isCurrentlySelectedUser
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .surface
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                        ))
                              ]
                            : []),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: SizedBox.square( dimension: 4,),
                        title: Text(
                      "selecteed property",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ));
                  },
                  itemCount: 2,
                )
              ],
            );
          });
    }
  }
}
