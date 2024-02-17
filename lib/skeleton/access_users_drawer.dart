import 'package:decla_time/core/constants/constants.dart';
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
        Positioned(
          top: kDrawerHandleButtonsFromTop,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.home_work_rounded),
              ),
            ),
          ),
        ),
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
