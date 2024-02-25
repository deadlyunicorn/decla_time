// ignore_for_file: always_specify_types

import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/users/drawer/users_drawer.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class SynchronizeDrawerButton extends StatelessWidget {
  const SynchronizeDrawerButton({
    required this.currentUser,
    required this.localized,
    super.key,
  });

  final String currentUser;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          final usersController = context.read<UsersController>();
          UsersDrawer.switchToDeclarationsPage(context);
          usersController.selectUser(currentUser);
          usersController.setRequestLogin(true);
        },
        child: Text(
          localized.sync.capitalized,
          maxLines: 1,
        ),
      ),
    );
  }
}
