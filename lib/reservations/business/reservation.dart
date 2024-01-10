import 'package:decla_time/core/enums/booking_platform.dart';

class Reservation{

  final String id;
  final DateTime arrivalDate;
  final DateTime departureDate;
  final double totalValue;
  final double hostPayout;
  final BookingPlatform bookingPlatform;

  Reservation({
    required this.id,
    required this.arrivalDate,
    required this.departureDate,
    required this.totalValue,
    required this.hostPayout,
    required this.bookingPlatform,
    
  }); 
  

}