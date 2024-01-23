// ignore_for_file: prefer_const_constructors

import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/date_pickers_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/id_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/listing_name_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/payout_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/platform_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/status_field.dart';
import 'package:decla_time/reservations_action_button_menu/reservation_manual_entry_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

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
  var idController = TextEditingController();
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
            PlatformField(
                localized: localized,
                platformNameController: platformNameController),
            SizedBox.square(
              dimension: 16,
            ),
            ListingNameField(
                localized: localized,
                listingNameController: listingNameController),
            IdField(idController: idController),
            Text(
              "Guest Name",
            ),
            PayoutField(
                payoutController: payoutController, localized: localized),
            DatePickersField(
                departureDate: departureDate,
                arrivalDate: arrivalDate,
                localized: localized),
            StatusField(localized: localized, reservationStatusController: reservationStatusController),
            TextButton(
              onPressed: () {
                _formKey.currentState!.validate();

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
