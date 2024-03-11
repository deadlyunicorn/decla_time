import "package:decla_time/core/widgets/custom_list_tile_outline.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/users/drawer/users/properties/friendly_name_dialog/friendly_name_dialog.dart";
import "package:decla_time/users/drawer/users_drawer.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class PropertiesList extends StatelessWidget {
  const PropertiesList({
    required this.properties,
    required this.localized,
    super.key,
  });

  final List<UserProperty> properties;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final UserProperty property = properties[index];
        return CustomListTileOutline(
          child: ListTile(
            onTap: () {
              context
                  .read<UsersController>()
                  .selectProperty(property.propertyId);
              UsersDrawer.switchToDeclarationsPage(context);
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => FriendlyNameDialog(
                  property: property,
                  localized: localized,
                ),
              );
            },
            title: Center(
              child: FittedBox(
                child: Column(
                  children: <Widget>[
                    if (property.friendlyName != null)
                      Text(
                        property.friendlyName!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      )
                    else ...<Widget>[
                      Text(
                        property.address,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        property.friendlyName ?? property.atak,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: properties.length,
    );
  }
}
