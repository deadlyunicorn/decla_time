import 'package:decla_time/skeleton/drawer_access_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UsersDrawerAccess extends StatelessWidget {
  const UsersDrawerAccess({
    super.key,
    required this.localized,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DrawerAccessButton(),
        Positioned(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: 96,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 4) {
                  Scaffold.of(context).openDrawer();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
