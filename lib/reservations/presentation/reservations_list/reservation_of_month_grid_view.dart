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
      ),
      itemCount:
          reservationsOfMonth.length * 2, //!TO BE CHANGED!!
      itemBuilder: (context, index) {
        final currentIndex =
            index % 3; //!TO BE CHANGED TO INDEX
    
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ReservationGridItem(reservationsOfMonth: reservationsOfMonth, currentIndex: currentIndex),
        );
      },
    );
  }
}
