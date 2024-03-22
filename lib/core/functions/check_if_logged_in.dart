import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

void navigatorLoginIfNeeded({
  required BuildContext context,
  required AppLocalizations localized,
}) {
  final UsersController usersController = context.read<UsersController>();
  if (usersController.loggedUser.headers == null) {
    usersController.setRequestLogin(true);
    Navigator.popUntil(
      context,
      (Route<void> route) => route.isFirst,
    );
    showErrorSnackbar(
      context: context,
      message: localized.notLoggedIn.capitalized,
    );
    throw NotLoggedInException();
  }
}
