import "package:decla_time/core/constants/constants.dart";
import "package:flutter/material.dart";

class IsSelectedUnderline extends StatelessWidget {
  const IsSelectedUnderline({
    required this.isSelected,
    super.key,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? AnimatedContainer(
            height: 3,
            width: kMaxContainerWidthSmall,
            duration: const Duration(
              milliseconds: 150,
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
          )
        : AnimatedContainer(
            height: 3,
            width: 2,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: Colors.green.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
          );
  }
}
