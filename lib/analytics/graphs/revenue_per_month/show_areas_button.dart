import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";

import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ShowAreasButton extends StatelessWidget {
  const ShowAreasButton({
    required this.showAreas,
    required this.setShowAreas,
    required this.localized,
    super.key,
  });

  final bool showAreas;
  final Function(bool?) setShowAreas;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(localized.area.capitalized),
        Checkbox(
          value: showAreas,
          onChanged: setShowAreas,
        ),
      ],
    );
  }
}
