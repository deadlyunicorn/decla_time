import 'package:flutter/material.dart';

class MinimalisticIconButton extends StatelessWidget {
  const MinimalisticIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateColor.resolveWith(
          (states) {
            if (states.contains(MaterialState.hovered) ||
                states.contains(MaterialState.pressed)) {
              return Colors.white;
            }
            return Theme.of(context).colorScheme.onBackground;
          },
        ),
        overlayColor: MaterialStateColor.resolveWith(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white.withAlpha(48);
            }
            return Colors.transparent;
          },
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
