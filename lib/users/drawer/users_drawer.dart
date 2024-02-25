import "package:decla_time/core/enums/selected_page.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/skeleton/selected_page_controller.dart";
import "package:decla_time/users/drawer/add_user_button.dart";
import "package:decla_time/users/drawer/drawer_outline.dart";
import "package:decla_time/users/drawer/users/users_list.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class UsersDrawer extends StatelessWidget {
  const UsersDrawer({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return DrawerOutline(
      child: ColumnWithSpacings(
        spacing: 16,
        children: <Widget>[
          Headline(localized: localized),
          const SizedBox.square(
            dimension: 16,
          ),
          UsersList(
            localized: localized,
          ),
          AddUserButton(
            onTap: () {
              context.read<UsersController>().selectUser("");
              switchToDeclarationsPage(context);
            },
            localized: localized,
          ),
        ],
      ),
    );
  }

  static void switchToDeclarationsPage(BuildContext context) {
    context
        .read<SelectedPageController>()
        .setSelectedPage(SelectedPage.declarations);
    Scaffold.of(context).closeDrawer();
  }
}

class Headline extends StatelessWidget {
  const Headline({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Text(
        localized.users.capitalized,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
