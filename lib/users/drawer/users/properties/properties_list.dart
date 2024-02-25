import "package:decla_time/core/widgets/custom_list_tile_outline.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/users/drawer/users_drawer.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class PropertiesList extends StatelessWidget {
  const PropertiesList({
    required this.properties,
    super.key,
  });

  final List<UserProperty> properties;

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
              //TODO Prompt to give a friendly name.
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
