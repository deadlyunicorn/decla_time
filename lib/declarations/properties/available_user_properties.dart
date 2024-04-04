import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/declarations/properties/property_sync_button.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class AvailableUserProperties extends StatefulWidget {
  const AvailableUserProperties({
    required this.userProperties,
    required this.localized,
    required this.currentUser,
    super.key,
  });

  @override
  State<AvailableUserProperties> createState() =>
      _AvailableUserPropertiesState();
  final List<UserProperty> userProperties;
  final AppLocalizations localized;
  final String currentUser;
}

class _AvailableUserPropertiesState extends State<AvailableUserProperties> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    final UserProperty? selectedProperty =
        context.select<UsersController, UserProperty?>(
      (UsersController controller) => widget.userProperties
          .where(
            (UserProperty property) =>
                controller.selectedProperty?.propertyId == property.propertyId,
          )
          .firstOrNull,
    );

    final String menuText = selectedProperty == null
        ? widget.localized.selectProperty.capitalized
        : propertyShortDetails(selectedProperty);

    final Iterable<AvailablePropertiesListTile> userPropertyEntries =
        widget.userProperties.map(
      (UserProperty property) {
        final String entryText = propertyShortDetails(property);

        return AvailablePropertiesListTile(
          onTap: () async {
            await context
                .read<UsersController>()
                .selectProperty(property.propertyId);
            setState(() {
              isOpen = false;
            });
          },
          child: Text(
            entryText,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );

    return ColumnWithSpacings(
      spacing: 4,
      children: <Widget>[
        AvailablePropertiesListTile(
          //TODO Doesn't work right now

          onTap: () {
            setState(() {
              isOpen = !isOpen;
            });
          },
          child: Text(menuText),
        ),
        if (isOpen) ...<Widget>[
          ...userPropertyEntries,
          PropertySyncButton(
            parentContext: context,
            localized: widget.localized,
          ),
        ],
      ],
    );
  }

  String propertyShortDetails(UserProperty property) =>
      property.friendlyName != null
          ? property.friendlyName!
          : "${property.address} - ${property.atak}";
  //? ATAK is more relevant to the end user than the propertyId..
}

class AvailablePropertiesListTile extends StatelessWidget {
  const AvailablePropertiesListTile({
    required this.onTap,
    super.key,
    this.icon,
    this.child,
  });

  final void Function() onTap;
  final Widget? child;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kMaxContainerWidthSmall * 2,
      height: 48,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        splashColor: Theme.of(context).colorScheme.secondary.withAlpha(128),
        tileColor: Theme.of(context).colorScheme.primary.withAlpha(128),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child:
              child, //! Be careful when the child is Text('') (empty string.)
        ),
        onTap: onTap,
        trailing: icon,
      ),
    );
  }
}
