import 'package:decla_time/core/enums/reservation_status.dart';
import 'package:flutter/material.dart';

class ReservationStatusDot extends StatelessWidget {

  final String reservationStatusString;
  
  const ReservationStatusDot({
    super.key,
    required this.reservationStatusString
  });

  @override
  Widget build(BuildContext context) {

    ReservationStatus reservationStatus = translateReservationStatus(reservationStatusString);

    switch( reservationStatus ){
      case ReservationStatus.completed:
        return const Icon( 
          size: 16,
          Icons.circle,
          color: Colors.green,
        );
      case ReservationStatus.upcoming:
        return Icon( 
          size: 16,
          Icons.circle,
          color: Theme.of(context).colorScheme.surface,
        );
      case ReservationStatus.cancelled:
        return Icon( 
          size: 16,
          Icons.circle,
          color: Theme.of( context ).colorScheme.error,
        );
    }
  }

  ReservationStatus translateReservationStatus( String reservationStatusString ){
    switch( reservationStatusString ){

      case "ok":
      case "completed":
        return ReservationStatus.completed;
      case "cancelled":
        return ReservationStatus.cancelled;
      default:
        return ReservationStatus.upcoming;

    }
  }
}