import 'package:flutter/material.dart';

class ColumnWithSpacings extends StatelessWidget {
  const ColumnWithSpacings({
    super.key,
    required this.children,
    required this.spacing,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  final List<Widget> children;
  final int spacing;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      children: children
          .map(
            (child) => Padding(
              padding: EdgeInsets.only(bottom: spacing.toDouble()),
              child: child,
            ),
          )
          .toList(),
    );
  }
}
