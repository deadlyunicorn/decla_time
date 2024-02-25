import "package:flutter/material.dart";

class ColumnWithSpacings extends StatelessWidget {
  const ColumnWithSpacings({
    required this.children,
    required this.spacing,
    super.key,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget> children;
  final int spacing;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children
          .map(
            (Widget child) => Padding(
              padding: EdgeInsets.only(bottom: spacing.toDouble()),
              child: child,
            ),
          )
          .toList(),
    );
  }
}
