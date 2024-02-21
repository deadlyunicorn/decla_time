import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/errors/exceptions.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/snackbars.dart';
import 'package:decla_time/declarations/utility/network_requests/get_user_properties.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class PropertySyncButton extends StatelessWidget {
  const PropertySyncButton({
    super.key,
    required this.localized,
    required this.setHelperText,
    required this.parentContext,
  });

  final AppLocalizations localized;
  final void Function(String) setHelperText;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
        onPressed: () async {
          //! Will instantly unmount. - that's why we use the parentContext.
          final userController = parentContext.read<UsersController>();
          final isarHelper = parentContext.read<IsarHelper>();
          final DeclarationsPageHeaders? headers =
              userController.loggedUser.headers;

          if (!userController.isLoggedIn || headers == null) {
            userController.setRequestLogin(true);
            return;
          }
          setHelperText("${localized.synchronizing.capitalized}...");
          try {
            final userProperties = await getUserProperties(headers);

            await isarHelper.userActions.addProperties(
              username: userController.selectedUser,
              propertyIterable: userProperties,
            );
          } on EntryAlreadyExistsException {
            if (!parentContext.mounted) return;
            showNormalSnackbar(
              context: parentContext,
              message: localized.noNewEntriesFound.capitalized,
            );
          } on NotLoggedInException {
            if (!parentContext.mounted) return;

            //TODO make it so that we refresh the cookies.
            showErrorSnackbar(
              context: parentContext,
              message: localized.errorLoginFailed.capitalized,
            );
          } on ClientException {
            if (!parentContext.mounted) return;
            showErrorSnackbar(
              context: parentContext,
              message: localized.errorNoConnection.capitalized,
            );
          } catch (any) {
            if (!parentContext.mounted) return;
            showErrorSnackbar(
              context: parentContext,
              message: localized.errorUnknown.capitalized,
            );
          }
          setHelperText("");
        },
        trailingIcon: const Icon(Icons.refresh),
        child: Text(
          localized.sync.capitalized,
        ));
  }
}
