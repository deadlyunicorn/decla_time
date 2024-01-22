// ignore_for_file: prefer_const_constructors

import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:flutter/material.dart';
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
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return RouteOutline(
      title: "Προσθήκη Κράτησης",
      child: Column(
        children: [
          Text("booking Platform"),
          FutureBuilder(
            future: getBookingPlatforms(),
            builder: (context, snapshot) {
              final List<String> dropdownMenuEntries = [
                ...(snapshot.data ?? []),
                localized.addNewPlatform.capitalized
              ];

              return DropdownMenu(
                controller: textEditingController,
                dropdownMenuEntries: [
                  ...dropdownMenuEntries.map(
                    (entryName) => DropdownMenuEntry(
                      value: entryName,
                      label: entryName,
                    ),
                  )
                ],
                onSelected: (value) {
                  if (value?.toLowerCase() == localized.addNewPlatform) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return PlatformAdditionAlertDialog(
                            refreshParent: () {
                              setState(() {});
                            },
                            dropdownMenuEntries: dropdownMenuEntries,
                          );
                        });
                  }
                },
              );
            },
          ),
          Text("Listing Name"),
          Text("ID"),
          Text("Guest Name"),
          Text("ArrivalDate"),
          Text("DepartureDate"),
          Text("Payout"),
          Text("Reservation Status"),
          TextButton(
              onPressed: () {
                widget.addToReservationsFoundSoFar(
                  [
                    Reservation(
                      bookingPlatform: "Manuual",
                      listingName: "Custom to be edited",
                      id: "ID",
                      guestName: "Someone",
                      arrivalDate: DateTime.now(),
                      departureDate: DateTime.now(),
                      payout: 121,
                      reservationStatus: "Έκλεισε",
                    )
                  ],
                );
              },
              child: Text("press mee")),
          Text("heehe"),
        ],
      ),
    );
  }

  Future<List<String>> getBookingPlatforms() async {
    final prefs = await SharedPreferences.getInstance();

    final bookingPlatforms = prefs.getStringList(kBookingPlatforms);
    if (bookingPlatforms != null) {
      return bookingPlatforms;
    } else {
      prefs.setStringList(kBookingPlatforms, ["Airbnb", "Booking.com"]);
      return ["Airbnb", "Booking.com"];
    }
  }
}

class PlatformAdditionAlertDialog extends StatefulWidget {
  const PlatformAdditionAlertDialog({
    super.key,
    required this.refreshParent,
    required this.dropdownMenuEntries,
  });

  final void Function() refreshParent;
  final List<String> dropdownMenuEntries;

  @override
  State<PlatformAdditionAlertDialog> createState() =>
      _PlatformAdditionAlertDialogState();
}

class _PlatformAdditionAlertDialogState
    extends State<PlatformAdditionAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController bookingPlatformNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return CustomAlertDialog(
      title: localized.platformAddition.capitalized,
      confirmButtonAction: () async {
        if (_formKey.currentState!.validate()) {
          Navigator.pop(context);

          SharedPreferences.getInstance().then((prefs) {
            prefs.setStringList(kBookingPlatforms,
                [...widget.dropdownMenuEntries, bookingPlatformNameController.text]);
            widget.refreshParent();
          });
        }
      },
      child: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
              hintText: localized.platformAdditionHint.capitalized),
          controller: bookingPlatformNameController,
          validator: (value) {
            if (value!.length < 6) {
              return localized.enterMin6Chars.capitalized;
            } else if (widget.dropdownMenuEntries.contains(value)) {
              return localized.bookingPlatformAlreadyExists.capitalized;
            }
            return null;
          },
        ),
        //( textController.text.length > 5 ),
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.confirmButtonAction,
    required this.title,
    required this.child,
  });

  final void Function() confirmButtonAction;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: kMaxWidthSmall,
        child: child,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(localized.cancel.capitalized)),
        TextButton(
          onPressed: () {
            confirmButtonAction();
          },
          child: Text(localized.confirm.capitalized),
        )
      ],
    );
  }
}
