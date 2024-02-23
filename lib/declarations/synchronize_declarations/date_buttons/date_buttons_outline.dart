import 'package:decla_time/core/constants/constants.dart';
import 'package:flutter/material.dart';

class DateButtonsOutline extends StatelessWidget {
  const DateButtonsOutline({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Flex(
        direction: MediaQuery.sizeOf(context).width < kMaxWidthSmall
            ? Axis.vertical
            : Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}
