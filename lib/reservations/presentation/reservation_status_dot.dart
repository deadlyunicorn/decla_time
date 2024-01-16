import 'package:decla_time/core/enums/reservation_status.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ReservationStatusDot extends StatelessWidget {

  final String reservationStatusString;
  final double size;

  const ReservationStatusDot({
    super.key,
    required this.reservationStatusString,
    this.size = 16

  });

  @override
  Widget build(BuildContext context) {

    final localized = AppLocalizations.of(context)!;
    ReservationStatus reservationStatus = translateReservationStatus(reservationStatusString);

    switch( reservationStatus ){
      case ReservationStatus.completed:
        return Tooltip(
          richMessage: TextSpan(text: localized.completed.capitalized),
          child: Icon( 
            Icons.circle,
            size: size,
            color: Colors.green,
          ),
        );
      case ReservationStatus.upcoming:
        return Tooltip(
          richMessage: TextSpan(text: localized.upcoming.capitalized),
          child: Icon( 
            Icons.circle,
            size: size,
            color: Theme.of(context).colorScheme.surface,
          ),
        );
      case ReservationStatus.cancelled:
        return Tooltip(
          richMessage: TextSpan(text: localized.cancelled.capitalized ),
          child: Icon( 
            Icons.circle,
            size: size,
            color: Theme.of( context ).colorScheme.error,
          ),
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