import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/widgets/minimalistic_icon_button.dart';
import 'package:flutter/material.dart';

class DrawerOutline extends StatelessWidget {
  const DrawerOutline({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: Stack(
        children: [
          Positioned(
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).closeDrawer();
              },
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(right: 48),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: kDrawerHandleButtonsFromTop),
                  child: child,
                ),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: kDrawerHandleButtonsFromTop,
            child: MinimalisticIconButton(
              icon: Icons.arrow_back_ios_rounded,
              onPressed: () {
                Scaffold.of(context).closeDrawer();
              },
            ),
          )
        ],
      ),
    );
  }
}
