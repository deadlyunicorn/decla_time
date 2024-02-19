import 'package:flutter/material.dart';

class ColumnWithSpacings extends StatelessWidget {
  const ColumnWithSpacings({
    super.key,
    required this.children,
    required this.spacing,
  });

  final List<Widget> children;
  final int spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children
          .map(
            (child) => Padding(
              padding: EdgeInsets.only(bottom: spacing.toDouble() ),
              child: child,
            ),
          )
          .toList(),
    );
  }
}
