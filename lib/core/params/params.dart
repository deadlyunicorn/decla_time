import 'package:decla_time/core/enums/booking_platform.dart';
import 'package:decla_time/core/enums/declaration_status.dart';

class NoParams {}

class BookingDetailsParams{

  final DateTime arrivalDate;
  final DateTime departureDate;
  final double totalValue;
  final double hostPayout;
  final BookingPlatform bookingPlatform;

  BookingDetailsParams({
    required this.arrivalDate,
    required this.departureDate,
    required this.totalValue,
    required this.hostPayout,
    required this.bookingPlatform,
  }); 

}

class DeclarationDetailsParams extends BookingDetailsParams{

  final DeclarationStatus declarationStatus;

  DeclarationDetailsParams({
    required super.arrivalDate,
    required super.departureDate,
    required super.totalValue,
    required super.hostPayout,
    required super.bookingPlatform,
    required this.declarationStatus
  });

}