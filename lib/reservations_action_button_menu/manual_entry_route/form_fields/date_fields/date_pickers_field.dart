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
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  const Text(
                    "Arrival Date:",
                  ),
                  TextButton(
                    onPressed: () {
                      handleArrivalDateButton(context);
                    },
                    child: const Text("aa"
                        // showDateOrSet(widget.arrivalDate),
                        ),
                    onHover: (isNotHovering) {
                    },
                  ),
                ],
              ),
              DateFieldWrap(
                title: "Departure Date",
                handleDateSetButton: handleDepartureDateButton,
                localized: localized,
                date: departureDate,
              ),
              Text(
                (departureDate != null && arrivalDate != null)
                    ? "The reservation took ${departureDate!.difference(arrivalDate!).inDays + 1} nights"
                    : "No info",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleArrivalDateButton(BuildContext context) async {
    //earliest possible date;
    final lastDate = departureDate ?? DateTime(1999);
    final arrivalDateTemp = await showDatePicker(
      context: context,
      firstDate: DateTime(1999),
      lastDate: departureDate != null
          ? lastDate.subtract( const Duration(days: 1))
          : DateTime(DateTime.now().year + 100),
      initialDate: arrivalDate ??
          (departureDate != null
              ? lastDate.subtract( const Duration(days: 1))
              : DateTime.now()),
      currentDate: DateTime.now(),
    );
    setArrivalDate(arrivalDateTemp);
  }

  Future<void> handleDepartureDateButton(BuildContext context) async {
    //earliest possible date;
    final firstDate = arrivalDate ?? DateTime(1999);

    final departureDateTemp = await showDatePicker(
      context: context,
      firstDate: firstDate.add( const Duration(days: 1)),
      lastDate: DateTime(DateTime.now().year + 100),
      initialDate: departureDate ??
          (arrivalDate != null
              ? firstDate.add( const Duration(days: 1))
              : DateTime.now()),
      currentDate: DateTime.now(),
    );
    setDepartureDate(departureDateTemp);
  }
}
