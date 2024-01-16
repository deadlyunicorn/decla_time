import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservation_details/reservation_details_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationDetailsRoute extends StatelessWidget {
  const ReservationDetailsRoute({
    super.key,
    required this.reservation,
  });

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 32,
              ),
              child: Column(
                children: [
                  Center(
                    child: 
                    Text(
                      "Details",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox.square(dimension: 16),
                  ReservationDetailsContainer(reservation: reservation),
                  const SizedBox.square(dimension: 16),
                  Text( formatLastEdit( reservation.lastEdit) ),
                ],
              ),
            ),
          )),
    );
  }

  String formatLastEdit( DateTime? lastEdit ){
    
    return lastEdit != null
      ?"Last Edit: ${ DateFormat( "dd/MM/y HH:mm").format(lastEdit)}" 
      :"";
  } 
}
