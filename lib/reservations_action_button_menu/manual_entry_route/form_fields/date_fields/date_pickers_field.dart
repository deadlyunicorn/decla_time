import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/night_or_nights.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/date_fields/date_field_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DatePickersField extends StatelessWidget {
  const DatePickersField({
    super.key,
    required this.departureDate,
    required this.arrivalDate,
    required this.localized,
    required this.setArrivalDate,
    required this.setDepartureDate,
  });

  final DateTime? departureDate;
  final DateTime? arrivalDate;
  final AppLocalizations localized;
  final void Function(DateTime? newDate) setArrivalDate;
  final void Function(DateTime? newDate) setDepartureDate;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.headlineSmall,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                DateFieldWrap(
                  label: localized.arrival.capitalized,
                  handleDateSetButton: handleArrivalDateButton,
                  localized: localized,
                  date: arrivalDate,
                ),
                DateFieldWrap(
                  label: localized.departure.capitalized,
                  handleDateSetButton: handleDepartureDateButton,
                  localized: localized,
                  date: departureDate,
                ),
              ],
            ),
            Text(
              (departureDate != null && arrivalDate != null)
                  ? "${localized.reservationLasted.capitalized} ${nightOrNights(localized, departureDate!.difference(arrivalDate!).inDays + 1)}"
                  : "",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> handleArrivalDateButton(BuildContext context) async {
    //earliest possible date;
    final lastDate = departureDate ?? DateTime(1999);
    final arrivalDateTemp = await showDatePicker(
      context: context,
      firstDate: DateTime(1999),
      lastDate: departureDate != null
          ? lastDate.subtract(const Duration(days: 1))
          : DateTime(DateTime.now().year + 100),
      initialDate: arrivalDate ??
          (departureDate != null
              ? lastDate.subtract(const Duration(days: 1))
              : DateTime.now()),
      currentDate: DateTime.now(),
    );
    if (arrivalDateTemp != null) {
      //Adds 13 hours
      setArrivalDate(arrivalDateTemp);
    }
    return arrivalDateTemp;
  }

  Future<DateTime?> handleDepartureDateButton(BuildContext context) async {
    //earliest possible date;
    final firstDate = arrivalDate ?? DateTime(1999);

    final departureDateTemp = await showDatePicker(
      context: context,
      firstDate: firstDate.add(const Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 100),
      initialDate: departureDate ??
          (arrivalDate != null
              ? firstDate.add(const Duration(days: 1))
              : DateTime.now()),
      currentDate: DateTime.now(),
    );
    if (departureDateTemp != null) {
      //Adds 11 hours
      setDepartureDate(departureDateTemp);
    }
    return departureDateTemp;
  }
}
