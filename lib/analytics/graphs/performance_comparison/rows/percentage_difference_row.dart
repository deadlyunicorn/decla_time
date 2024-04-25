import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class PercentageDifferenceRow extends StatelessWidget {
  const PercentageDifferenceRow({
    required this.localized,
    required this.nightsFilledPercentageDifference,
    required this.textColor,
    required this.recentFilledPercentage,
    required this.olderFilledPercentage,
    super.key,
  });

  final AppLocalizations localized;
  final double recentFilledPercentage;
  final double olderFilledPercentage;
  final double nightsFilledPercentageDifference;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("${localized.filledPercentage.capitalized}: "),
        Tooltip(
          textAlign: TextAlign.center,
          message:
              // ignore: lines_longer_than_80_chars
              "${localized.current.capitalized}: ${(recentFilledPercentage * 100).toStringAsFixed(2)}%\n"
              // ignore: lines_longer_than_80_chars
              "${localized.previous.capitalized}: ${(olderFilledPercentage * 100).toStringAsFixed(2)}%"
          // ignore: lines_longer_than_80_chars
          ,
          child: Text(
            "${nightsFilledPercentageDifference > 0? "+": ""}"
            "${((nightsFilledPercentageDifference) * 100).toStringAsFixed(2)}%",
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
