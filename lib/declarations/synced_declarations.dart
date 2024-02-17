import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/errors/exceptions.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/show_error_snackbar.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:decla_time/declarations/login/user_credentials_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SyncedDeclarations extends StatelessWidget {
  final AppLocalizations localized;

  const SyncedDeclarations({
    super.key,
    required this.localized,
  });

  @override
  Widget build(BuildContext context) {
    final declarationsAccountProvider =
        context.watch<DeclarationsAccountController>();

    void displayError(String message) {
      showErrorSnackbar(
        context: context,
        message: message,
      );
    }

    return Column(
      children: [
        Text(
          //TODO REMOVE THIS
          declarationsAccountProvider.userCredentials?.username ??
              " no username?",
        ),
        Text(
          //TODO REMOVE THIS
          declarationsAccountProvider.headers?.gsisCookie ?? "",
        ),
        TextButton(
            onPressed: () async {
              final isarHelper =
                  context.read<IsarHelper>();
              final users = await isarHelper.userActions.getAll();
              if (users.isEmpty) {
                await isarHelper.userActions.add(username: "testUser");
              } else {
                final testUser = users.first;
                if (testUser.propertyIds.isEmpty) {
                  try {
                    await isarHelper.userActions.addProperty(
                      username: testUser.username,
                      property: UserProperty(
                        propertyId: "test123",
                        address: "home address",
                        atak: "Free attack",
                        serialNumber: "no serial numbers",
                      ),
                    );
                  } on EntryAlreadyExistsException {
                    displayError(localized.errorAlreadyRegistered.capitalized);
                  } catch (error) {
                    displayError(localized.errorUnknown);
                  }
                } else {
                  final properties = await isarHelper.userActions
                      .getProperties(username: testUser.username);
                  for (var element in properties) {
                    print(element.propertyId);
                  }
                }
              }
            },
            child: const Text("add properties"))
      ],
    );
  }
}
