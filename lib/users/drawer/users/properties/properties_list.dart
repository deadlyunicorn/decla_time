import 'package:decla_time/core/widgets/custom_list_tile_outline.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:decla_time/users/drawer/users_drawer.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PropertiesList extends StatelessWidget {
  const PropertiesList({
    super.key,
    required this.properties,
  });

  final List<UserProperty> properties;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
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
              title: Text(
                property.friendlyName ??
                    property
                        .atak, //? ATAK is more relevant to the end user than the propertyId..
                style: Theme.of(context).textTheme.bodyMedium,
              )),
        );
      },
      itemCount: properties.length,
    );
  }
}
