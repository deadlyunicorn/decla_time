import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/custom_list_tile_outline.dart';
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
    required this.switchToDeclarationsPage,
  });

  final List<User> users;
  final AppLocalizations localized;
  final void Function() switchToDeclarationsPage;

  @override
  Widget build(BuildContext context) {
    final usersController = context.watch<UsersController>();
    final String loggedInUser =
        context.watch<UsersController>().loggedUser.userCredentials?.username ??
            "";

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
            final String currentUser = users[index].username;
            final bool isLoggedInUser = loggedInUser == currentUser;
            final bool isSelectedUser = //? We will underline the selected property...
                usersController.selectedUser == currentUser;

            return Column(
              children: [
                CustomListTileOutline(
                  child: ListTile(
                    trailing: isLoggedInUser
                        ? const Icon(Icons.cloud_done_rounded)
                        : const SizedBox.shrink(),
                    title: Text(
                      currentUser,
                    ),
                    onLongPress: () {
                      print("deleting user");
                    },
                    onTap: () {
                      usersController.selectUser(currentUser);
                      switchToDeclarationsPage();
                    },
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: CustomListTileOutline(
                        child: ListTile(
                            onTap: () {
                              print("no wayy");
                            },
                            title: Text(
                              "selecteed property",
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                      ),
                    );
                  },
                  itemCount: 2,
                )
              ],
            );
          });
    }
  }
}
