import "package:decla_time/core/enums/booking_platform.dart";
import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/functions/fasthash.dart";
import "package:intl/intl.dart";
import "package:isar/isar.dart";

part "declaration.g.dart";

@collection
class Declaration {
  @Enumerated(EnumType.name)
  final BookingPlatform bookingPlatform;

  final String propertyId;

  @Enumerated(EnumType.name)
  final DeclarationStatus declarationStatus;

  final DateTime arrivalDate;
  final DateTime departureDate;
  final double payout;

  final DateTime? cancellationDate;
  final double? cancellationAmount;

  @Index(unique: true)
  final int declarationDbId;

  @Index(unique: true)
  int? serialNumber; //used for getting finalized declaration details.

  Declaration({
    required this.propertyId,
    required this.declarationDbId,
    required this.bookingPlatform,
    required this.arrivalDate,
    required this.departureDate,
    required this.payout,
    this.declarationStatus = DeclarationStatus.temporary,
    this.cancellationDate,
    this.cancellationAmount,
    this.serialNumber,
  });

  int get nights => departureDate.difference(arrivalDate).inDays + 1;
  String get arrivalDateString => DateFormat("dd/MM/y").format(arrivalDate);
  String get departureDateString => DateFormat("dd/MM/y").format(departureDate);
  Id get isarId => fastHash("$declarationDbId");

  bool isEqualTo(Declaration declaration) {
    return declaration.propertyId == propertyId &&
        declaration.declarationDbId == declarationDbId &&
        declaration.declarationStatus == declarationStatus &&
        declaration.cancellationDate == cancellationDate &&
        declaration.cancellationAmount == cancellationAmount &&
        declaration.bookingPlatform == bookingPlatform &&
        declaration.arrivalDate == arrivalDate &&
        declaration.departureDate == departureDate &&
        declaration.payout == payout &&
        declaration.serialNumber == serialNumber;
  }
}
