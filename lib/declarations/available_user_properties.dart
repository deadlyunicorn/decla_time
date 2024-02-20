import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/widgets/column_with_spacings.dart';
import 'package:decla_time/declarations/database/user/user_property.dart';
import 'package:flutter/material.dart';

class AvailableUserProperties extends StatefulWidget {
  const AvailableUserProperties({
    super.key,
    required this.userProperties,
  });

  final List<UserProperty> userProperties;

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
    final userPropertyEntries = widget.userProperties.map(
      (property) => MenuItemButton(
        onPressed: () {
          print("set selected property to ${property.propertyId}");
        },
        child: const Text(
          "property.address",
        ),
      ),
    );

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
                          await Future.delayed(Duration(seconds: 2));
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
