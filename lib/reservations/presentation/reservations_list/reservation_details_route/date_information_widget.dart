import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DateInformationWidget extends StatelessWidget {
  const DateInformationWidget({
    required this.reservation,
    required this.nights,
    required this.localized,
    super.key,
  });

  final Reservation reservation;
  final int nights;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kMaxWidthSmall,
      child: Column(
        //Dates and Nights
        children: <Widget>[
          Flex(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            direction: Axis.horizontal,
            children: <Widget>[
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
            children: <Widget>[
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
          Text(
            "${localized.nights.capitalized}: $nights",
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  String dateFormat(DateTime date) {
    return DateFormat("dd/MM/y").format(date);
  }
}
