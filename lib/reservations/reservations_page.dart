import 'package:decla_time/reservations/presentation/reservations_list.dart';
import 'package:flutter/material.dart';

class ReservationsPage extends StatelessWidget {

  const ReservationsPage({ super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric( horizontal: 16, vertical: 32),
      child: ReservationsList(),
    );
  }
}