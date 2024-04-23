import "package:flutter_gen/gen_l10n/app_localizations.dart";

String nightOrNights(AppLocalizations localized, int nights) {
  if (nights <= 1) {
    return "$nights ${localized.night}";
  } else {
    return "$nights ${localized.nights}";
  }
}

String reservationOrReservations(AppLocalizations localized, int reservations) {
  if (reservations <= 1) {
    return "$reservations ${localized.reservation}";
  } else {
    return "$reservations ${localized.reservations}";
  }
}
