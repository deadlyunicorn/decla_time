
class Reservation{
  
  final String bookingPlatform;
  final String? listingName;

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
    required this.reservationStatus
    
  }); 
  

}