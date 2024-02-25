import "package:flutter/material.dart";

class CustomListTileOutline extends StatelessWidget {
  const CustomListTileOutline({
    required this.child,
    super.key,
    this.isSelected = false,
  });

  final ListTile child;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Theme.of(context).colorScheme.primary : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(child: child),
    );
  }
}
