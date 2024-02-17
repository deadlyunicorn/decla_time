import 'package:decla_time/core/enums/selected_page.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/skeleton/selected_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';


class AddUserButton extends StatelessWidget {
  const AddUserButton({
    super.key, required this.localized,
  });
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        child: ListTile(
          onTap: () {
            context.read<SelectedPageController>().setSelectedPage( SelectedPage.declarations );
            Scaffold.of(context).closeDrawer();
          },
          titleAlignment: ListTileTitleAlignment.center,
          title: Center(child: Text(localized.add.capitalized)),
        ),
      ),
    );
  }
}
