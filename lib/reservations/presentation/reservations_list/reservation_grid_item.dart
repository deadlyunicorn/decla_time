import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservation_status_dot.dart';
import 'package:flutter/material.dart';

class ReservationGridItem extends StatelessWidget {
  const ReservationGridItem({
    super.key,
    required this.reservationsOfMonth,
    required this.currentIndex,
  });

  final List<Reservation> reservationsOfMonth;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(reservationsOfMonth[currentIndex]
                .guestName),
            Text(
                "${reservationsOfMonth[currentIndex].payout} €"),
            Text(
                "${reservationsOfMonth[currentIndex].departureDate.difference(reservationsOfMonth[currentIndex].arrivalDate).inDays + 1} nights"),
            ReservationStatusDot(
                reservationStatusString:
                    reservationsOfMonth[currentIndex]
                        .reservationStatus)
          ],
        ),
      ),
    );
  }
}
