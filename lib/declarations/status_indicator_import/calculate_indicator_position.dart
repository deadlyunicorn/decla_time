import "dart:math";
import "package:decla_time/declarations/status_indicator_import/status_indicator.dart";
import "package:flutter/material.dart";

class CalculateIndicatorPosition extends StatefulWidget {
  const CalculateIndicatorPosition({required this.child, super.key});

  final Widget child;

  @override
  CalculateIndicatorPositionState createState() =>
      CalculateIndicatorPositionState();
}

class CalculateIndicatorPositionState
    extends State<CalculateIndicatorPosition> {
  //TODO on Android it doesn't move as smooth as on PC.
  double rightOffset = double.infinity;
  double topOffset = 0;

  @override
  Widget build(BuildContext context) {
    const double padding = 8;
    return Positioned(
      left: min(
        MediaQuery.sizeOf(context).width -
            StatusIndicatorImport.buttonSize -
            padding,
        max(
          padding,
          rightOffset,
        ),
      ),
      top: min(
        MediaQuery.sizeOf(context).height -
            64 * 3 -
            StatusIndicatorImport.buttonSize -
            padding,
        max(padding + 64, topOffset),
      ),
      child: Container(
        height: StatusIndicatorImport.buttonSize,
        width: StatusIndicatorImport.buttonSize,
        color: Colors.transparent,
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            setState(() {
              rightOffset = details.globalPosition.dx -
                  StatusIndicatorImport.buttonSize / 2;
              topOffset = details.globalPosition.dy -
                  StatusIndicatorImport.buttonSize / 2;
            });
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            setState(() {
              rightOffset = details.globalPosition.dx -
                  StatusIndicatorImport.buttonSize / 2;
              topOffset = details.globalPosition.dy -
                  StatusIndicatorImport.buttonSize / 2;
            });
          },
          child: widget.child,
        ),
      ),
    );
  }
}
