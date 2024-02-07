import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservation_details_route/reservation_editing_route.dart';
import 'package:flutter/material.dart';

class ReservationEditButton extends StatelessWidget {
  const ReservationEditButton({
    super.key,
    required this.reservation,
    required this.size,
  });

  final Reservation reservation;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ReservationEditingRoute(
                  reservation: reservation,
                );
              },
            ),
          );
        },
        child: const Icon(
          Icons.edit,
          size: 24,
          color: Colors.amber,
        ),
      ),
    );
  }
}
