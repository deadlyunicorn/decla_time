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
  });

  final AppLocalizations localized;
  final void Function(String) setHelperText;

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
        onPressed: () async {
          final userController = context.read<UsersController>();
          if (!userController.isLoggedIn) {
            userController.setRequestLogin(true);
            return;
          }
          setHelperText("${localized.synchronizing.capitalized}...");
          try {
            final DeclarationsPageHeaders? headers =
                userController.loggedUser.headers;
            if (headers == null) throw NotLoggedInException();

            final userProperties = await getUserProperties(headers);

            if (context.mounted) {
              await context.read<IsarHelper>().userActions.addProperties(
                    username: userController.selectedUser,
                    propertyIterable: userProperties,
                  );
            }
          } on EntryAlreadyExistsException {
            if (!context.mounted) return;
            showNormalSnackbar(
              context: context,
              message: localized.noNewEntriesFound.capitalized,
            );
          } on NotLoggedInException {
            if (!context.mounted) return;

            //TODO make it so that we refresh the cookies.
            showErrorSnackbar(
              context: context,
              message: localized.errorLoginFailed.capitalized,
            );
          } on ClientException {
            if (!context.mounted) return;
            showErrorSnackbar(
              context: context,
              message: localized.errorNoConnection.capitalized,
            );
          } catch (any) {
            if (!context.mounted) return;
            showErrorSnackbar(
              context: context,
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
