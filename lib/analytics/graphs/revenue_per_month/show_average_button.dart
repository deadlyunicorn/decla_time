import "package:flutter/material.dart";

class ShowAverageButton extends StatelessWidget {
  const ShowAverageButton({
    required this.showAverage,
    required this.setShowAverage,
    super.key,
  });

  final bool showAverage;
  final Function(bool?) setShowAverage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Average"),
        Checkbox(
          value: showAverage,
          onChanged: setShowAverage,
        ),
      ],
    );
  }
}
