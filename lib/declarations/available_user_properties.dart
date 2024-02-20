import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/errors/exceptions.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/snackbars.dart';
import 'package:decla_time/core/widgets/column_with_spacings.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:decla_time/declarations/utility/network_requests/get_user_properties.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AvailableUserProperties extends StatefulWidget {
  const AvailableUserProperties({
    super.key,
    required this.userProperties,
    required this.localized,
    required this.currentUser,
  });

  final List<UserProperty> userProperties;
  final AppLocalizations localized;
  final String currentUser;

  @override
  State<AvailableUserProperties> createState() =>
      _AvailableUserPropertiesState();
}

class _AvailableUserPropertiesState extends State<AvailableUserProperties> {
  String helperText = "";
  String menuText = "localized.select an option";

  @override
  void initState() {
    super.initState();
    if (widget.userProperties.isEmpty) {
      helperText = "localized no entries found";
    }
  }

  @override
  Widget build(BuildContext context) {
    displayError({required String message}) {
      showErrorSnackbar(context: context, message: message);
    }

    display({required String message}) {
      showNormalSnackbar(context: context, message: message);
    }

    final userPropertyEntries = widget.userProperties.map((property) {
      final String entryText = "${property.address} - ${property.atak}";

      return MenuItemButton(
        onPressed: () {
          print("set selected property to ${property.propertyId}");
          setState(() {
            menuText = entryText;
          });
        },
        child: Text(entryText),
      );
    });

    return MenuButtonTheme(
      data: MenuButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.background,
          ),
          fixedSize: const MaterialStatePropertyAll(
            Size(kMaxContainerWidthSmall * 2, 48),
          ),
        ),
      ),
      child: ColumnWithSpacings(
        spacing: 8,
        children: [
          MenuBar(
            children: [
              SizedBox(
                width: kMaxContainerWidthSmall * 2,
                child: SubmenuButton(
                  menuStyle: const MenuStyle(
                    maximumSize: MaterialStatePropertyAll(
                      Size(
                        double.infinity,
                        256,
                      ),
                    ),
                  ),
                  menuChildren: [
                    MenuItemButton(
                        onPressed: () async {
                          setState(() {
                            helperText = "Synchronizing..";
                          });
                          if (!context.read<UsersController>().isLoggedIn) {
                            context
                                .read<UsersController>()
                                .setRequestLogin(true);
                                return;
                          }
                          try {
                            final DeclarationsPageHeaders? headers = context
                                .read<UsersController>()
                                .loggedUser
                                .headers;
                            if (headers == null) throw NotLoggedInException();
                            final userProperties =
                                await getUserProperties(headers);

                            if (context.mounted) {
                              await context
                                  .read<IsarHelper>()
                                  .userActions
                                  .addProperties(
                                    username: widget.currentUser,
                                    propertyIterable: userProperties,
                                  );
                            }

                            // throw NotLoggedInException();
                          } on EntryAlreadyExistsException {
                            display(message: "localized.no new found");
                          } on NotLoggedInException {
                            //TODO make it so that we refresh the cookies.
                            displayError(
                              message:
                                  widget.localized.errorLoginFailed.capitalized,
                            );
                          } on ClientException {
                            displayError(
                              message: widget
                                  .localized.errorNoConnection.capitalized,
                            );
                          } catch (any) {
                            displayError(
                              message:
                                  widget.localized.errorUnknown.capitalized,
                            );
                          }
                          setState(() {
                            helperText = "No entries found.";
                          });
                          print("Synchronize things of user");
                        },
                        child: Text(
                          "localized.synchronize",
                        )),
                    ...userPropertyEntries
                  ],
                  child: Text(
                    menuText,
                  ),
                ),
              ),
            ],
          ),
          Text(helperText)
        ],
      ),
    );
  }
}
