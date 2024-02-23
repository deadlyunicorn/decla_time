import 'package:decla_time/core/widgets/custom_list_tile_outline.dart';
import 'package:decla_time/users/drawer/users_drawer.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDrawerTile extends StatelessWidget {
  const UserDrawerTile({
    super.key,
    required this.currentUser,
  });

  final String currentUser;

  @override
  Widget build(BuildContext context) {
    final usersController = context.watch<UsersController>();
    final bool isLoggedInUser =
        currentUser == usersController.loggedUser.userCredentials?.username;
    final bool isSelectedUser = 
        usersController.selectedUser == currentUser;

    return Tooltip(
      message: currentUser,
      child: CustomListTileOutline(
        isSelected: isSelectedUser,
        child: ListTile(
          trailing: isLoggedInUser
              ? const Icon(Icons.cloud_done_rounded)
              : const SizedBox.shrink(),
          title: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                currentUser,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          onLongPress: () {
            //TODO Prompt to delete user. ( and the relevant database entries..)
          },
          onTap: () {
            usersController.selectUser(currentUser);
            usersController.setRequestLogin(false);
            UsersDrawer.switchToDeclarationsPage(context);
          },
        ),
      ),
    );
  }
}
