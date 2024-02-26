// ignore_for_file: always_specify_types

import "package:decla_time/status_indicator/animations.dart";
import "package:decla_time/status_indicator/calculate_indicator_position.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;
  static const double buttonSize = 48;

  @override
  Widget build(BuildContext context) {
    bool isVisible = true; //context.select((value) => isUploading);

    return CalculateIndicatorPosition(
      child: TextButton(
        style: TextButton.styleFrom().copyWith(
          shape: const MaterialStatePropertyAll(
            CircleBorder(),
          ),
        ),
        onPressed: () {
          // setState(() {
          // isVisible = !isVisible;
          // });
        },
        child: const AnimationTest2(), //AnimationTest2(animation: _animation),
      ),
    );
  }
}
