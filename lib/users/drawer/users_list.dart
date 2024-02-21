import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/custom_list_tile_outline.dart';
import 'package:decla_time/declarations/database/user/user.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersList extends StatelessWidget {
  const UsersList({
    super.key,
    required this.localized,
    required this.switchToDeclarationsPage,
  });

  final AppLocalizations localized;
  final void Function() switchToDeclarationsPage;

  @override
  Widget build(BuildContext context) {
    final usersController = context.watch<UsersController>();
    final users = usersController.users;
    final String loggedInUser =
        usersController.loggedUser.userCredentials?.username ?? "";

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
            final bool
                isSelectedUser = //? We will underline the selected property...
                usersController.selectedUser == currentUser;

            return Column(
              children: [
                Tooltip(
                  message: currentUser,
                  child: CustomListTileOutline(
                    child: ListTile(
                      trailing: isLoggedInUser
                          ? const Icon(Icons.cloud_done_rounded)
                          : const SizedBox.shrink(),
                      title: Text(
                        currentUser,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onLongPress: () {
                        //TODO Prompt to delete user. ( and the relevant database entries..)
                      },
                      onTap: () {
                        usersController.selectUser(currentUser);
                        usersController.setRequestLogin(false);
                        switchToDeclarationsPage();
                      },
                    ),
                  ),
                ),
                FutureBuilder<Set<UserProperty>>(
                    future: context
                        .read<IsarHelper>()
                        .userActions
                        .readProperties(username: currentUser),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final properties = snapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: properties.isNotEmpty
                              ? PropertiesList(properties: properties.toList())
                              : CustomListTileOutline(
                                  child: ListTile(
                                    title: Center(
                                      child: TextButton(
                                        onPressed: () {
                                          switchToDeclarationsPage();
                                        },
                                        child: Text(localized.sync.capitalized),
                                      ),
                                    ),
                                  ),
                                ),
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
                    })
              ],
            );
          });
    }
  }
}

class PropertiesList extends StatelessWidget {
  const PropertiesList({
    super.key,
    required this.properties,
  });

  final List<UserProperty> properties;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final UserProperty property = properties[index];
        return CustomListTileOutline(
          child: ListTile(
              onTap: () {
                //TODO Select the selected property. => The reservations section adds to this property.
              },
              onLongPress: () {
                //TODO Prompt to give a friendly name.
              },
              title: Text(
                property.friendlyName ??
                    property
                        .atak, //? ATAK is more relevant to the end user than the propertyId..
                style: Theme.of(context).textTheme.bodyMedium,
              )),
        );
      },
      itemCount: properties.length,
    );
  }
}
