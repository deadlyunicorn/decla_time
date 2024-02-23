import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/errors/exceptions.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/snackbars.dart';
import 'package:decla_time/declarations/properties/available_user_properties.dart';
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
    required this.parentContext,
    required this.closeMenu,
  });

  final AppLocalizations localized;
  final BuildContext parentContext;
  final void Function() closeMenu;

  @override
  Widget build(BuildContext context) {
    return AvailablePropertiesListTile(
        onTap: () async {
          //! Will instantly unmount. - that's why we use the parentContext.
          final userController = parentContext.read<UsersController>();
          final isarHelper = parentContext.read<IsarHelper>();
          final DeclarationsPageHeaders? headers =
              userController.loggedUser.headers;

          if (!userController.isLoggedIn || headers == null) {
            userController.setRequestLogin(true);
            return;
          }
          showNormalSnackbar(
            context: parentContext,
            message: "${localized.synchronizing.capitalized}...",
          );
          try {
            final userProperties = await getUserProperties(headers);

            await isarHelper.userActions.addProperties(
              username: userController.selectedUser,
              propertyIterable: userProperties,
            );

            final propertiesCount = userProperties.length;

            if (!parentContext.mounted) return;
            showNormalSnackbar(
              context: parentContext,
              message:
                  "${localized.found.capitalized}: $propertiesCount ${propertiesCount > 1 ? localized.properties : localized.property} ",
            );
          } on EntryAlreadyExistsException {
            if (!parentContext.mounted) return;
            showNormalSnackbar(
              context: parentContext,
              message: localized.noNewPropertiesFound.capitalized,
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
          closeMenu();
        },
        icon: const Icon(Icons.refresh),
        child: Text(
          localized.syncProperties.capitalized,
        ));
  }
}
