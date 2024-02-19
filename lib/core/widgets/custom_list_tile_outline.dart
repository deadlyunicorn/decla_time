import 'package:flutter/material.dart';

class CustomListTileOutline extends StatelessWidget {
  const CustomListTileOutline({super.key, required this.child});

  final ListTile child;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(child: child),
    );
  }
}
