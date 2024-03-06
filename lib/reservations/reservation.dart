import "package:decla_time/core/functions/fasthash.dart";
import "package:decla_time/core/widgets/generic_calendar_grid_view/generic_calendar_grid_view.dart";
import "package:intl/intl.dart";
import "package:isar/isar.dart";

part "reservation.g.dart";

@collection
class Reservation implements ItemWithDates{
  final String bookingPlatform;
  final String? listingName;

  DateTime? lastEdit;
  bool isDeclared;

  @Index(unique: true)
  final String id;
  final String guestName;
  @override
  final DateTime arrivalDate;
  @override
  final DateTime departureDate;
  final double payout;
  final String reservationStatus;

  Reservation({
    required this.bookingPlatform,
    required this.listingName,
    required this.id,
    required this.guestName,
    required this.arrivalDate,
    required this.departureDate,
    required this.payout,
    required this.reservationStatus,
    this.isDeclared = false,
    this.lastEdit,
  });

  int get nights => departureDate.difference(arrivalDate).inDays + 1;
  String get arrivalDateString => DateFormat("dd/MM/y").format(arrivalDate);
  String get departureDateString => DateFormat("dd/MM/y").format(departureDate);
  Id get isarId => fastHash(id);

  bool isEqualTo(Reservation reservation) {
    return reservation.bookingPlatform == bookingPlatform &&
        reservation.listingName == listingName &&
        reservation.id == id &&
        reservation.guestName == guestName &&
        reservation.arrivalDate == arrivalDate &&
        reservation.departureDate == departureDate &&
        reservation.payout == payout &&
        reservation.reservationStatus == reservationStatus &&
        reservation.isDeclared == isDeclared;
  }
}
