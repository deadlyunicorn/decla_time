import 'package:flutter/material.dart';

class IsSelectedUnderline extends StatelessWidget {
  const IsSelectedUnderline({
    super.key,
    required this.isSelected,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? AnimatedContainer(
            height: 3,
            width: 120,
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
