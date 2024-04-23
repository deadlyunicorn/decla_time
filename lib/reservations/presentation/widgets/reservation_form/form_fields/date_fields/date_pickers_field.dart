import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/plurals.dart";
import "package:decla_time/core/widgets/custom_date_picker.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/date_fields/date_field_wrap.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DatePickersField extends StatelessWidget {
  const DatePickersField({
    required this.departureDate,
    required this.arrivalDate,
    required this.localized,
    required this.setArrivalDate,
    required this.setDepartureDate,
    super.key,
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
          children: <Widget>[
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: <Widget>[
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
                  // ignore: lines_longer_than_80_chars
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
    final DateTime lastDate = departureDate ?? DateTime(1999);
    final DateTime? arrivalDateTemp = await showCustomDatePicker(
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
    final DateTime firstDate = arrivalDate ?? DateTime(1999);

    final DateTime? departureDateTemp = await showCustomDatePicker(
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
