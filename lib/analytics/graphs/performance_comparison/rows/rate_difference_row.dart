import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class RateDifferenceRow extends StatelessWidget {
  const RateDifferenceRow({
    required this.localized,
    required this.averageDailyRateDifference,
    required this.recentDailyRate,
    required this.olderDailyRate,
    required this.textColor,
    super.key,
  });

  final AppLocalizations localized;
  final double recentDailyRate;
  final double olderDailyRate;
  final double averageDailyRateDifference;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text("${localized.nightlyRate.capitalized}: "),
        Tooltip(
          textAlign: TextAlign.center,
          message:
              // ignore: lines_longer_than_80_chars
              "${localized.current.capitalized}: ${recentDailyRate.toStringAsFixed(2)} EUR\n"
              // ignore: lines_longer_than_80_chars
              "${localized.previous.capitalized}: ${olderDailyRate.toStringAsFixed(2)} EUR\n"
              "${averageDailyRateDifference > 0 ? "+" : ""}"
              // ignore: lines_longer_than_80_chars
              "${(averageDailyRateDifference * 30).toStringAsFixed(2)} EUR/30 ${localized.nights}",
          child: Text(
            "${averageDailyRateDifference > 0 ? "+" : ""}"
            "${(averageDailyRateDifference).toStringAsFixed(2)} EUR/${localized.night}",
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
