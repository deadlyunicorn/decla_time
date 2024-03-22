import "package:flutter/material.dart";

class HelperTextDisplay extends StatelessWidget {
  const HelperTextDisplay({
    required this.helperText,
    required this.isSyncing,
    super.key,
  });

  final String helperText;
  final bool isSyncing;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: -128 - 64,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Text(
              helperText,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                shadows: <Shadow>[
                  BoxShadow(
                    blurRadius: 2,
                    color: Colors.black,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            if (isSyncing)
              const Positioned(
                bottom: -64,
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
