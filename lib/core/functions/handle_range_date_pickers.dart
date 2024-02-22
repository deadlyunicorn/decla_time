import 'package:flutter/material.dart';

Future<DateTime?> handleArrivalDatePicker({
  required BuildContext context,
  DateTime? departureDate,
  DateTime? arrivalDate,
}) async {
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

  return arrivalDateTemp;
}

Future<DateTime?> handleDepartureDatePicker({
  required BuildContext context,
  DateTime? departureDate,
  DateTime? arrivalDate,
}) async {
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

  return departureDateTemp;
}
