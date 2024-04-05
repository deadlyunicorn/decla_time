import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/night_or_nights.dart";
import "package:decla_time/core/widgets/generic_calendar_grid_view/generic_calendar_grid_view.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:intl/intl.dart";

class DateInformationWidget<T extends ItemWithDates> extends StatelessWidget {
  
  const DateInformationWidget({
    required this.item,
    required this.nights,
    required this.localized,
    super.key,
  });

  final T item;
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
                  dateFormat(item.arrivalDate),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  dateFormat(item.departureDate),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Text(
            nightOrNights(localized, nights),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  static String dateFormat(DateTime date) {
    return DateFormat("dd/MM/y").format(date);
  }
}
