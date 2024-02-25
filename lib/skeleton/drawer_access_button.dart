import "dart:math";

import "package:decla_time/core/constants/constants.dart";
import "package:flutter/material.dart";

class DrawerAccessButton extends StatefulWidget {
  const DrawerAccessButton({
    super.key,
  });

  @override
  State<DrawerAccessButton> createState() => _DrawerAccessButtonState();
}

class _DrawerAccessButtonState extends State<DrawerAccessButton> {
  double distanceFromTop = kDrawerHandleButtonsFromTop;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: distanceFromTop,
      left: 0,
      child: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails details) {
          final double newDistance = min(
            max(
              kDrawerHandleButtonsFromTop,
              distanceFromTop + details.delta.dy,
            ),
            MediaQuery.sizeOf(context).height - 128,
          );
          setState(() {
            distanceFromTop = newDistance;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(8)),
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
    );
  }
}
