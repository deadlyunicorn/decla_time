import 'package:decla_time/declarations/login/login_form.dart';
import 'package:decla_time/declarations/synced_declarations.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeclarationsPage extends StatelessWidget {
  const DeclarationsPage({super.key, required this.localized});

  final AppLocalizations localized;
  @override
  Widget build(BuildContext context) {

    final usersController = context.watch<UsersController>();
    final selectedUser = usersController.selectedUser;
    final isLoggedIn = usersController.isLoggedIn;
    final requestLogin = usersController.requestLogin;


    return SingleChildScrollView(
      child: ( selectedUser.isNotEmpty && !requestLogin ) || isLoggedIn
          ? SyncedDeclarations(
              localized: localized,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                  child: LoginForm(
                initialUsername: selectedUser,
                localized: localized,
              )),
            ),
    );
  }
}
