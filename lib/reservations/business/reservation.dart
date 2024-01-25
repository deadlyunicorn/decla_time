import 'package:decla_time/core/functions/fasthash.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

part 'reservation.g.dart';

@collection
class Reservation{
  
  final String bookingPlatform;
  final String? listingName;

  DateTime? lastEdit;
  bool isDeclared;

  @Index(unique: true)
  final String id;
  final String guestName;
  final DateTime arrivalDate;
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

    this.lastEdit,
    this.isDeclared = false
    
  }); 

  int get nights => departureDate.difference( arrivalDate ).inDays + 1 ; 
  String get arrivalDateString => DateFormat("dd/MM/y").format( arrivalDate );
  String get departureDateString => DateFormat("dd/MM/y").format( departureDate );
  Id get isarId => fastHash( id );
  

}