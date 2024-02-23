import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/column_with_spacings.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:decla_time/declarations/properties/property_sync_button.dart';
import 'package:decla_time/users/drawer/users/properties/properties_list.dart';
import 'package:decla_time/users/users_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AvailableUserProperties extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final selectedProperty = context.select<UsersController, UserProperty?>(
      (controller) => userProperties
          .where(
              (property) => controller.selectedProperty == property.propertyId)
          .firstOrNull,
    );

    final menuText = selectedProperty == null
        ? localized.selectProperty.capitalized
        : propertyShortDetails(selectedProperty);

    final userPropertyEntries = userProperties.map(
      (property) {
        final String entryText = propertyShortDetails(property);

        return MenuItemButton(
          onPressed: () async {
            await context
                .read<UsersController>()
                .selectProperty(property.propertyId);
          },
          child: SizedBox(
            width: kMaxContainerWidthSmall * 2 - 24,
            child: Text(
              entryText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );

    return MenuButtonTheme(
      data: MenuButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.primary,
          ),
          overlayColor: MaterialStatePropertyAll( Theme.of(context).colorScheme.secondary.withAlpha(48) ),
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
                    surfaceTintColor:
                        MaterialStatePropertyAll(Colors.transparent),
                  ),
                  menuChildren: [
                    ColumnWithSpacings(
                      spacing: 4,
                      children: [
                        const SizedBox.shrink(),
                        ...userPropertyEntries,
                        PropertySyncButton(
                          parentContext: context,
                          localized: localized,
                        ),
                      ],
                    )
                  ],
                  child: SizedBox(
                    width: kMaxContainerWidthSmall * 2 - 24,
                    child: Text(
                      menuText,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  String propertyShortDetails(UserProperty property) =>
      "${property.address} - ${property.atak}"; //? ATAK is more relevant to the end user than the propertyId..
}
