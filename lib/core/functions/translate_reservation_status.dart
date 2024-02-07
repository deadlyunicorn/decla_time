import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/enums/reservation_status.dart';

ReservationStatus translateReservationStatus( String reservationStatusString ){
    switch( reservationStatusString.toLowerCase() ){

      case "ok":
      case kCompleted:
      case "past guest":
      case "awaiting guest review":
        return ReservationStatus.completed;
      case kCancelled:
      case "cancelled_by_guest":
        return ReservationStatus.cancelled;
      default:
        return ReservationStatus.upcoming;

    }
  }