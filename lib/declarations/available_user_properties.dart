import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/column_with_spacings.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:decla_time/declarations/property_sync_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String menuText = "";

  @override
  void initState() {
    super.initState();
    menuText = widget.localized.select.capitalized;
  }

  @override
  Widget build(BuildContext context) {
    final userPropertyEntries = widget.userProperties.map((property) {
      final String entryText = "${property.address} - ${property.atak}";

      return MenuItemButton(
        onPressed: () {
          //TODO MenuText takes from selectedPropertyId.
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
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll(
            Theme.of(context).colorScheme.primary.withAlpha(48),
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
                          localized: widget.localized,
                          setHelperText: setHelperText,
                        ),
                      ],
                    )
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

  void setHelperText(String newText) {
    if (newText == helperText) return;
    setState(() {
      helperText = newText;
    });
  }
}
