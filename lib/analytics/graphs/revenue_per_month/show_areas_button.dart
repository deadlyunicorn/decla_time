import "package:flutter/material.dart";

class ShowAreasButton extends StatelessWidget {
  const ShowAreasButton({
    required this.showAreas,
    required this.setShowAreas,
    super.key,
  });

  final bool showAreas;
  final Function(bool?) setShowAreas;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("Areas"),
        Checkbox(
          value: showAreas,
          onChanged: setShowAreas,
        ),
      ],
    );
  }
}
