import "package:flutter_gen/gen_l10n/app_localizations.dart";

String nightOrNights(AppLocalizations localized, int nights) {
  if (nights <= 1) {
    return "$nights ${localized.night}";
  } else {
    return "$nights ${localized.nights}";
  }
}
