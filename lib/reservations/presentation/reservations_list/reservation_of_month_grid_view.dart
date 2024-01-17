import 'dart:math';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservation_grid_item.dart';
import 'package:flutter/material.dart';

class ReservationOfMonthGridView extends StatelessWidget {
  const ReservationOfMonthGridView({
    super.key,
    required this.reservationsOfMonth,
  });

  final List<Reservation> reservationsOfMonth;

  @override
  Widget build(BuildContext context) {

    final horizontalPadding =
        min((MediaQuery.sizeOf(context).width ~/ 64), 36).toDouble();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 160.0,
        crossAxisSpacing: horizontalPadding,
        mainAxisSpacing: 16
      ),
      itemCount:
          reservationsOfMonth.length,
      itemBuilder: (context, index) {
    
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ReservationGridItem( reservation: reservationsOfMonth[index] ),
        );
      },
    );
  }
}
