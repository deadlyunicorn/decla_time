import "package:flutter/material.dart";

class AnimatedDropDownIcon extends StatelessWidget {
  const AnimatedDropDownIcon({
    required this.isOpen,
    super.key,
  });

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isOpen ? -1 / 4 : 0,
      duration: const Duration(milliseconds: 160),
      child: const Icon(Icons.arrow_drop_down_circle_outlined),
    );
  }
}
