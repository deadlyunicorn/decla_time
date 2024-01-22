// ignore_for_file: prefer_const_constructors

import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations_action_button_menu/reservation_manual_entry_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManualReservationEntryRoute extends StatefulWidget {
  const ManualReservationEntryRoute({
    super.key,
    required this.addToReservationsFoundSoFar,
  });

  final void Function(Iterable<Reservation> list) addToReservationsFoundSoFar;

  @override
  State<ManualReservationEntryRoute> createState() =>
      _ManualReservationEntryRouteState();
}

class _ManualReservationEntryRouteState
    extends State<ManualReservationEntryRoute> {
  final _formKey = GlobalKey<FormState>();
  var platformNameController = TextEditingController();
  var listingNameController = TextEditingController();
  var guestNameController = TextEditingController();
  DateTime? arrivalDate;
  DateTime? departureDate;
  var payoutController = TextEditingController();
  var reservationStatusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return RouteOutline(
      title: "Προσθήκη Κράτησης",
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ReservationManualEntryField(
              localized: localized,
              textEditingController: platformNameController,
              sharedPrefsListKey: kBookingPlatforms,
              headlineText: "Platform",
              hintText: "Platform",
              defaultDropdownEntries: ["Airbnb", "Booking.com"]
                  .map((platformEntry) => DropdownMenuEntry(
                      value: platformEntry, label: platformEntry))
                  .toList(),
            ),
            SizedBox.square(
              dimension: 16,
            ),
            ReservationManualEntryField(
              localized: localized,
              textEditingController: listingNameController,
              sharedPrefsListKey: kReservationListing,
              headlineText: "Listing name",
              hintText: "Listing",
            ),
            Text(
              "ID",
            ),
            Text(
              "Guest Name",
            ),
            Text("Payout"),
            SizedBox(
              width: kMaxContainerWidthSmall,
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9.,]"))
                ],
                controller: payoutController,
                decoration: InputDecoration(
                  errorMaxLines: 2,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (RegExp("[0-9]+[.,][0-9][0-9]\$").hasMatch(value ?? "")) {
                    return null;
                  } else {
                    return "Invalid Format. Please make sure your Format is like so: 457.00";
                  }
                },
              ),
            ),
            Row(
              children: [
                Text("hello"),
                TextButton(
                  onPressed: () async {
                    final arrivalDateTemp = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1999),
                      lastDate:
                          departureDate ?? DateTime(DateTime.now().year + 100),
                      initialDate:
                          arrivalDate ?? (departureDate ?? DateTime.now()),
                      currentDate: DateTime.now(),
                    );
                    setState(() {
                      arrivalDate = arrivalDateTemp?.add(Duration(hours: 13));
                    });
                  },
                  child: Text("Arrival Date"),
                ),
                TextButton(
                  onPressed: () async {
                    final departureDateTemp = await showDatePicker(
                      context: context,
                      firstDate: arrivalDate ?? DateTime(1999),
                      lastDate: DateTime(DateTime.now().year + 100),
                      initialDate:
                          departureDate ?? (arrivalDate ?? DateTime.now()),
                      currentDate: DateTime.now(),
                    );
                    setState(() {
                      departureDate =
                          departureDateTemp?.add(Duration(hours: 11));
                    });
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
            ReservationManualEntryField(
              localized: localized,
              textEditingController: reservationStatusController,
              sharedPrefsListKey: kReservationStatus,
              headlineText: "Status",
              hintText: "Status",
              defaultDropdownEntries: [
                DropdownMenuEntry(
                  value: kCompleted,
                  label: localized.completed.capitalized,
                ),
                DropdownMenuEntry(
                  value: kCancelled,
                  label: localized.cancelled.capitalized,
                ),
                DropdownMenuEntry(
                  value: kUpcoming,
                  label: localized.upcoming.capitalized,
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // widget.addToReservationsFoundSoFar(
                //   [
                //     Reservation(
                //       bookingPlatform: "Manuual",
                //       listingName: "Custom to be edited",
                //       id: "ID",
                //       guestName: "Someone",
                //       arrivalDate: DateTime.now(),
                //       departureDate: DateTime.now(),
                //       payout: 121,
                //       reservationStatus: "Έκλεισε",
                //     )
                //   ],
                // );
                _formKey.currentState!.validate();
              },
              child: Text("press mee"),
            ),
            Text("heehe"),
          ],
        ),
      ),
    );
  }
}
