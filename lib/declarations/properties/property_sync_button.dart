import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/snackbars.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/declarations/properties/available_user_properties.dart";
import "package:decla_time/declarations/utility/network_requests/get_user_properties.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:http/http.dart";
import "package:provider/provider.dart";

class PropertySyncButton extends StatefulWidget {
  const PropertySyncButton({
    required this.localized,
    required this.parentContext,
    super.key,
  });

  final AppLocalizations localized;
  final BuildContext parentContext;

  @override
  State<PropertySyncButton> createState() => _PropertySyncButtonState();
}

class _PropertySyncButtonState extends State<PropertySyncButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AvailablePropertiesListTile(
      onTap: syncProperties,
      icon: StreamBuilder<int>(
        stream: rotationStream(isLoading),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return AnimatedRotation(
              turns: snapshot.data! * 0.1,
              duration: const Duration(milliseconds: 1000),
              child: const Icon(Icons.refresh),
            );
          } else {
            return AnimatedRotation(
              turns: (snapshot.data != null ? snapshot.data! * 0.1 : 0)
                  .roundToDouble(),
              duration: const Duration(milliseconds: 1000),
              child: const Icon(Icons.refresh),
            );
          }
        },
      ),
      child: Text(
        widget.localized.syncProperties.capitalized,
      ),
    );
  }

  Stream<int> rotationStream(bool isRunning) async* {
    int i = 0;
    while (isRunning) {
      yield ++i;
      await Future<void>.delayed(const Duration(milliseconds: 96));
    }
  }

  Future<void> syncProperties() async {
    setState(() {
      isLoading = true;
    });
    //! Will instantly unmount. - that's why we use the parentContext.
    final UsersController userController =
        widget.parentContext.read<UsersController>();
    final IsarHelper isarHelper = widget.parentContext.read<IsarHelper>();
    final DeclarationsPageHeaders? headers = userController.loggedUser.headers;

    if (!userController.isLoggedIn || headers == null) {
      userController.setRequestLogin(true);
      return;
    }
    showNormalSnackbar(
      context: widget.parentContext,
      message: "${widget.localized.synchronizing.capitalized}...",
    );
    try {
      final List<UserProperty> userProperties =
          await getUserProperties(headers);

      await isarHelper.userActions.addProperties(
        username: userController.selectedUser,
        propertyIterable: userProperties,
      );

      final int propertiesCount = userProperties.length;

      if (!widget.parentContext.mounted) return;
      showNormalSnackbar(
        context: widget.parentContext,
        message:
            // ignore: lines_longer_than_80_chars
            "${widget.localized.found.capitalized}: $propertiesCount ${propertiesCount > 1 ? widget.localized.properties : widget.localized.property} ",
      );
    } on EntryAlreadyExistsException {
      if (!widget.parentContext.mounted) return;
      showNormalSnackbar(
        context: widget.parentContext,
        message: widget.localized.noNewPropertiesFound.capitalized,
      );
    } on NotLoggedInException {
      if (mounted) {
        final LoggedUser loggedUser =
            context.read<UsersController>().loggedUser;
        final UserCredentials? userCredentials = loggedUser.userCredentials;
        if (userCredentials == null) {
          context.read<UsersController>().setRequestLogin(true);
          Navigator.of(context).pop();
          return;
        }
        loggedUser.setDeclarationsPageHeaders(
          await loginUser(credentials: userCredentials),
        );
        await syncProperties(); //TODO Untested.
      }
    } on ClientException {
      if (!widget.parentContext.mounted) return;
      showErrorSnackbar(
        context: widget.parentContext,
        message: widget.localized.errorNoConnection.capitalized,
      );
    } catch (any) {
      if (!widget.parentContext.mounted) return;
      showErrorSnackbar(
        context: widget.parentContext,
        message: widget.localized.errorUnknown.capitalized,
      );
    }
    setState(() {
      isLoading = false;
    });
  }
}
