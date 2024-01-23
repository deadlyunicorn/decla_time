// ignore_for_file: prefer_const_constructors

import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DatePickersField extends StatelessWidget {
  const DatePickersField({
    super.key,
    required this.departureDate,
    required this.arrivalDate,
    required this.localized,
  });

  final DateTime? departureDate;
  final DateTime? arrivalDate;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () async {
                final arrivalDateTemp = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1999),
                  lastDate:
                      departureDate ?? DateTime(DateTime.now().year + 100),
                  initialDate: arrivalDate ?? (departureDate ?? DateTime.now()),
                  currentDate: DateTime.now(),
                );
                // setState(() {
                //   arrivalDate = arrivalDateTemp?.add(Duration(hours: 13));
                // });
              },
              child: Text(
                arrivalDate != null
                    ? DateFormat('dd/MM/y').format(arrivalDate!)
                    : localized.set.capitalized,
              ),
            ),
            TextButton(
              onPressed: () async {
                final departureDateTemp = await showDatePicker(
                  context: context,
                  firstDate: arrivalDate ?? DateTime(1999),
                  lastDate: DateTime(DateTime.now().year + 100),
                  initialDate: departureDate ?? (arrivalDate ?? DateTime.now()),
                  currentDate: DateTime.now(),
                );
                // setState(() {
                //   departureDate =
                //       departureDateTemp?.add(Duration(hours: 11));
                // });
              },
              child: Text("Departure Date"),
            )
          ],
        ),
        Text(
          (departureDate != null && arrivalDate != null)
              ? "The reservation took ${departureDate?.difference(arrivalDate!).inDays} nights"
              : "No info",
        ),
      ],
    );
  }
}
