import "package:decla_time/core/enums/booking_platform.dart";
import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/functions/fasthash.dart";
import "package:decla_time/core/widgets/generic_calendar_grid_view/generic_calendar_grid_view.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:intl/intl.dart";
import "package:isar/isar.dart";

part "declaration.g.dart";

@collection
class Declaration implements ItemWithDates {
  @Enumerated(EnumType.name)
  final BookingPlatform bookingPlatform;

  final String propertyId;

  @Enumerated(EnumType.name)
  final DeclarationStatus declarationStatus;

  @override
  final DateTime arrivalDate;
  @override
  final DateTime departureDate;
  final double payout;

  final DateTime? cancellationDate;
  final double? cancellationAmount;

  @Index(unique: true)
  final int declarationDbId;

  final int? serialNumber;

  const Declaration({
    required this.propertyId,
    required this.declarationDbId,
    required this.bookingPlatform,
    required this.arrivalDate,
    required this.departureDate,
    required this.payout,
    required this.declarationStatus,
    required this.serialNumber,
    this.cancellationDate,
    this.cancellationAmount,
  });

  int get nights => departureDate.difference(arrivalDate).inDays;
  String? get cancellationDateString => cancellationDate != null
      ? DateFormat("dd/MM/y").format(cancellationDate!)
      : null;
  String get arrivalDateString => DateFormat("dd/MM/y").format(arrivalDate);
  String get departureDateString => DateFormat("dd/MM/y").format(departureDate);
  Id get isarId => fastHash("$declarationDbId");

  static String getLocalizedDeclarationStatus({
    required AppLocalizations localized,
    required DeclarationStatus declarationStatus,
  }) {
    switch (declarationStatus) {
      case (DeclarationStatus.finalized):
        return localized.declarationStatusFinalized;

      case (DeclarationStatus.temporary):
        return localized.declarationStatusTemporary;

      default:
        return localized.declarationStatusUndeclared;
    }
  }

  bool isEqualTo(Declaration declaration) {
    return declaration.propertyId == propertyId &&
        declaration.declarationDbId == declarationDbId &&
        declaration.declarationStatus == declarationStatus &&
        declaration.cancellationDate == cancellationDate &&
        declaration.cancellationAmount == cancellationAmount &&
        declaration.bookingPlatform == bookingPlatform &&
        declaration.arrivalDate == arrivalDate &&
        declaration.departureDate == departureDate &&
        declaration.payout == payout;
  }
}
