import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/enums/reservation_status.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

ReservationStatus translateReservationStatus(
    String reservationStatusString, AppLocalizations localized) {
  final Map<String, ReservationStatus> reservationStatusSet = {
    "ok": ReservationStatus.completed,
    kCompleted: ReservationStatus.completed,
    "past guest": ReservationStatus.completed,
    localized.completed: ReservationStatus.completed,
    "awaiting guest review": ReservationStatus.completed,
    kCancelled: ReservationStatus.cancelled,
    localized.cancelled: ReservationStatus.cancelled,
    "cancelled_by_guest": ReservationStatus.cancelled,
  };
  return reservationStatusSet[reservationStatusString.toLowerCase()] ??
      ReservationStatus.upcoming;
}
