import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/custom_list_tile_outline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddUserButton extends StatelessWidget {
  const AddUserButton({
    super.key,
    required this.localized,
    required this.onTap,
  });
  final AppLocalizations localized;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CustomListTileOutline(
      child: ListTile(
        onTap: onTap,
        titleAlignment: ListTileTitleAlignment.center,
        title: Center(
          child: FittedBox(
            child: Text(
              localized.add.capitalized,
            ),
          ),
        ),
      ),
    );
  }
}
