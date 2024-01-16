import 'dart:math';

import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservation_status_dot.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservation_details/reservation_details_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationGridItem extends StatelessWidget {
  const ReservationGridItem({
    super.key,
    required this.reservationsOfMonth,
    required this.currentIndex,
  });

  final List<Reservation> reservationsOfMonth;
  final int currentIndex;

  int get nights =>
      reservationsOfMonth[currentIndex]
          .departureDate
          .difference(reservationsOfMonth[currentIndex].arrivalDate)
          .inDays +
      1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ReservationDetailsRoute(
                    reservation: reservationsOfMonth[currentIndex],
                  );
                },
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondary),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    reservationsOfMonth[currentIndex].guestName,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${reservationsOfMonth[currentIndex].payout}€",
                    style: Theme.of(context).textTheme.headlineSmall!,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  Text(
                    "$nights nights",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: ReservationStatusDot(
            reservationStatusString:
                reservationsOfMonth[currentIndex].reservationStatus,
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: Text( DateFormat( "dd" ).format( reservationsOfMonth[currentIndex].departureDate )  )
        ),
      ],
    );
  }
}
