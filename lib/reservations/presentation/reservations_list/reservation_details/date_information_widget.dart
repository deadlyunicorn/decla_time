import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    final localized = AppLocalizations.of(context)!;

    return SizedBox(
      width: 400,
      child: Column(
        //Dates and Nights
        children: [
          Flex(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Text(
                  localized.arrival.capitalized,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Expanded(
                child: Text(
                  localized.departure.capitalized,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  dateFormat(reservation.departureDate),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Text("${localized.nights.capitalized}: $nights"),
        ],
      ),
    );
  }

  String dateFormat(DateTime date) {
    return DateFormat("dd/MM/y").format(date);
  }
}
