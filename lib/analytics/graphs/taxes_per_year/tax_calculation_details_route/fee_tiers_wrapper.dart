import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class FeeTier {
  FeeTier({
    required this.feeFactor,
    required this.thresholdString,
    required this.threshHold,
  });

  final double feeFactor;
  final String thresholdString;
  final int threshHold;
}

class FeeTiersWrapper extends StatelessWidget {
  const FeeTiersWrapper({
    required this.localized,
    required this.grossValue,
    required this.feeTier,
    super.key,
  });

  final AppLocalizations localized;
  final double grossValue;
  final FeeTier feeTier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          childrenPadding: const EdgeInsets.symmetric(vertical: 16),
          title: Text(
            // ignore: lines_longer_than_80_chars
            "${localized.yearlyIncome.capitalized} ${feeTier.thresholdString} EUR: \n"
            // ignore: lines_longer_than_80_chars
            "${localized.feeFactor.capitalized} ${(feeTier.feeFactor * 100).toStringAsFixed(2)}%",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          children: <Widget>[
            Text(
              "${localized.forGross.capitalized} "
              // ignore: lines_longer_than_80_chars
              "${(feeTier.threshHold - 1).toStringAsFixed(2)}EUR ${localized.feeExampleString01} "
              // ignore: lines_longer_than_80_chars
              "${((feeTier.threshHold - 1) * feeTier.feeFactor).toStringAsFixed(2)}EUR ${localized.feeExampleString02} "
              // ignore: lines_longer_than_80_chars
              "${((feeTier.threshHold - 1) * (1 - feeTier.feeFactor)).toStringAsFixed(2)}EUR ${localized.net}",
              textAlign: TextAlign.center,
            ),
            Text(
              // ignore: lines_longer_than_80_chars
              "\n${localized.basedOnImports.capitalized} (${localized.atleast.capitalized} ${localized.forGross} ${grossValue.toStringAsFixed(2)}EUR):",
              textAlign: TextAlign.center,
            ),
            Text(
              "${localized.net.capitalized}: "
              // ignore: lines_longer_than_80_chars
              "${(grossValue * (1 - feeTier.feeFactor)).toStringAsFixed(2)}EUR",
              style: TextStyle(
                color: Colors.greenAccent.shade700,
              ),
            ),
            Text(
              "${localized.fees.capitalized}: "
              // ignore: lines_longer_than_80_chars
              "${(grossValue * feeTier.feeFactor).toStringAsFixed(2)}EUR",
              style: TextStyle(
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
        const SizedBox.square(
          dimension: 16,
        ),
      ],
    );
  }
}
