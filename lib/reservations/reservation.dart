import "package:decla_time/core/enums/booking_platform.dart";
import "package:decla_time/core/functions/fasthash.dart";
import "package:decla_time/core/widgets/generic_calendar_grid_view/generic_calendar_grid_view.dart";
import "package:intl/intl.dart";
import "package:isar/isar.dart";

part "reservation.g.dart";

@collection
class Reservation implements ItemWithDates {
  //TODO !! Some reservations are "CANCELLED" and show some amount ( of what would be the income if it was not cancelled)
  //TODO !! However the income is 0 - find a way to exclude those.

  @Enumerated(EnumType.name)
  final BookingPlatform bookingPlatform;

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

  final DateTime? cancellationDate;
  final double? cancellationAmount;

  final int? reservationPlaceId;

  Reservation({
    required this.bookingPlatform,
    required this.listingName,
    required this.id,
    required this.guestName,
    required this.arrivalDate,
    required this.departureDate,
    required this.payout,
    required this.reservationStatus,
    required this.cancellationDate,
    required this.cancellationAmount,
    required this.reservationPlaceId,
    this.isDeclared = false,
    this.lastEdit,
  });

  int get nights => departureDate.difference(arrivalDate).inDays + 1;
  String get arrivalDateString => DateFormat("dd/MM/y").format(arrivalDate);
  String get departureDateString => DateFormat("dd/MM/y").format(departureDate);
  Id get isarId => fastHash(id);

  double get dailyRate => ((cancellationAmount ?? 0) + payout) / nights;

  Reservation copyWith({
    BookingPlatform? bookingPlatform,
    String? listingName,
    String? id,
    String? guestName,
    DateTime? arrivalDate,
    DateTime? departureDate,
    double? payout,
    String? reservationStatus,
    DateTime? cancellationDate,
    double? cancellationAmount,
    bool? isDeclared,
    DateTime? lastEdit,
    int? reservationPlaceId,
  }) =>
      Reservation(
        bookingPlatform: bookingPlatform ?? this.bookingPlatform,
        listingName: listingName ?? this.listingName,
        id: id ?? this.id,
        guestName: guestName ?? this.guestName,
        arrivalDate: arrivalDate ?? this.arrivalDate,
        departureDate: departureDate ?? this.departureDate,
        payout: payout ?? this.payout,
        reservationStatus: reservationStatus ?? this.reservationStatus,
        cancellationDate: cancellationDate ?? this.cancellationDate,
        cancellationAmount: cancellationAmount ?? this.cancellationAmount,
        lastEdit: lastEdit ?? this.lastEdit,
        isDeclared: isDeclared ?? this.isDeclared,
        reservationPlaceId: reservationPlaceId ?? this.reservationPlaceId,
      );

  bool isEqualTo(Reservation reservation) {
    return reservation.bookingPlatform == bookingPlatform &&
        reservation.listingName == listingName &&
        reservation.id == id &&
        reservation.guestName == guestName &&
        reservation.arrivalDate == arrivalDate &&
        reservation.departureDate == departureDate &&
        reservation.payout == payout &&
        reservation.reservationStatus == reservationStatus &&
        reservation.isDeclared == isDeclared &&
        reservation.reservationPlaceId == reservationPlaceId &&
        reservation.cancellationAmount == cancellationAmount &&
        reservation.cancellationDate == cancellationDate;
  }
}
