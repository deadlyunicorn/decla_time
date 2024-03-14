import "package:decla_time/core/widgets/route_outline.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DeclarationSubmitRoute extends StatelessWidget {
  //TODO HERE I AM RIGHT NOW, be sure to test those.
  const DeclarationSubmitRoute({
    required this.localized,
    required this.selectedProperty,
    super.key,
  });

  final AppLocalizations localized;
  final UserProperty selectedProperty;

  @override
  Widget build(BuildContext context) {
    return RouteOutline(
      title: localized.addEntries,
      child: Column(
        children: <Widget>[
          Text(
            "Select reservations to declare for ${selectedProperty.friendlyName ?? ""}\n${selectedProperty.formattedPropertyDetails}",
          ),
          Text("hello world?"),
        ],
      ),
    );
  }
}
