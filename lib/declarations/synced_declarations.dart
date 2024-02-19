import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/errors/exceptions.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/show_error_snackbar.dart';
import 'package:decla_time/core/widgets/column_with_spacings.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:decla_time/users/users_controller.dart';
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
    final usersController = context.watch<UsersController>();

    //TODO!!! display declarations even if the user is not logged in ( if they are synced. ?)

    //TODO We need to add a property select --grid-- DropDown List? -> SYnc Now is an option of the list. ( and handle the ( initial ) case where there are no properties in the local db)
    //TODO We need to add a SYNC properties button ( that exists even after we have synced our local properties - in case there are changes. )

    //TODO After we sync the properties we need to SYNC the existing declarations

    //TODO When submitting declarations:
    //TODO + We have a 'queue' where we can add from our reservation list
    //TODO + We can press "SYNC NOW" to start syncing one by one. ( rate limit )

    //TODO Handle 302 - Log out etc.

    //TODO + After we submit our declaration we can read the response body or headers( location->url ) to check the declarationDbId.

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: ColumnWithSpacings(
        spacing: 16,
        children: [
          Text(
            "Viewing the  of ${usersController.selectedUser}",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          FutureBuilder(
            future: readPropertiesFuture(
                //TODO FINISH THIS
                context: context,
                selectedUser: usersController.selectedUser),
            builder: (context, snapshot) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          TextButton(
            onPressed: () async {
              if (!usersController.isLoggedIn) {
                usersController.setRequestLogin(true);
              }
            },
            child: const Text("add properties"), //?Sync Button
          )
        ],
      ),
    );
  }

  Future<Set<UserProperty>> readPropertiesFuture( //?Read == Local
      {required BuildContext context, required String selectedUser}) async {
    final isarHelper = context.read<IsarHelper>();
    return await isarHelper.userActions.readProperties(username: selectedUser);
  }

  Future<void> testFunc1(
      BuildContext context, void displayError(String message)) async {
    final isarHelper = context.read<IsarHelper>();
    final users = await isarHelper.userActions.getAll();
    if (users.isEmpty) {
      await isarHelper.userActions.addNew(username: "testUser");
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
            .readProperties(username: testUser.username);
        for (var element in properties) {
          print(element.propertyId);
        }
      }
    }
  }
}
