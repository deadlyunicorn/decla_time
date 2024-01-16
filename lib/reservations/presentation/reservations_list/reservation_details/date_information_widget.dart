import 'package:decla_time/reservations/business/reservation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInformationWidget extends StatelessWidget {
  const DateInformationWidget({
    super.key,
    required this.reservation,
    required this.nights,
  });

  final Reservation reservation;
  final int nights;

  @override
  Widget build(BuildContext context) {
    return Column(
      //Dates and Nights
      children: [
        Flex(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Text(
                "Arrival",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded(
              child: Text(
                "Departure",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Text(
                dateFormat(reservation.arrivalDate),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                dateFormat(reservation.departureDate),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Text("Nights: $nights"),
      ],
    );
  }

  String dateFormat(DateTime date) {
    return DateFormat("dd/MM/y").format(date);
  }
}
