import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/declarations/login/login_form.dart";
import "package:decla_time/declarations/property_selector.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class DeclarationsPage extends StatelessWidget {
  const DeclarationsPage({
    required this.localized,
    required this.scrollController,
    super.key,
  });

  final AppLocalizations localized;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final UsersController usersController = context.watch<UsersController>();
    final String selectedUser = usersController.selectedUser;
    final bool isLoggedIn = usersController.isLoggedIn;
    final bool requestLogin = usersController.requestLogin;

    return SingleChildScrollView(
      controller: scrollController,
      child: Center(
        child: SizedBox(
          width: kMaxWidthLargest,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
            child: (selectedUser.isNotEmpty && !requestLogin) || isLoggedIn
                ? PropertySelector(
                    localized: localized,
                  )
                : LoginForm(
                    initialUsername: selectedUser,
                    localized: localized,
                  ),
          ),
        ),
      ),
    );
  }
}
