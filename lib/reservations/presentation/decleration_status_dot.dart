import 'package:flutter/material.dart';

class DeclarationStatusDot extends StatelessWidget {
  final bool isDeclared;
  final double size;

  const DeclarationStatusDot({
      super.key, 
      required this.isDeclared,
      this.size = 16
    });

  @override
  Widget build(BuildContext context) {
    if ( isDeclared ) {
      return Tooltip(
        richMessage: const TextSpan(text: "Declared"),
        child: Icon(
          Icons.done,
          size: size,
          color: Colors.green,
        ),
      );
    } else {
      return Tooltip(
        richMessage: const TextSpan(text: "Undeclared"),
        child: Icon(
          Icons.cancel,
          size: size,
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
