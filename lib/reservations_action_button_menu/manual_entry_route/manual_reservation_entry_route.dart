import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/date_fields/date_pickers_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/id_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/listing_name_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/payout_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/platform_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/status_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      title: localized.manualAddition.capitalized,
      child: SizedBox(
        width: kMaxWidthLargest,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  PlatformField(
                    localized: localized,
                    platformNameController: platformNameController,
                  ),
                  ListingNameField(
                    localized: localized,
                    listingNameController: listingNameController,
                  ),
                  StatusField(
                    localized: localized,
                    reservationStatusController: reservationStatusController,
                  ),
                ],
              ),

              IdField(idController: idController),
              Text(
                localized.guestName.capitalized,
              ),
              PayoutField(
                payoutController: payoutController,
                localized: localized,
              ),
              DatePickersField(
                departureDate: departureDate,
                arrivalDate: arrivalDate,
                localized: localized,
                setArrivalDate: setArrivalDate,
                setDepartureDate: setDapartureDate,
              ),
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
                child: Text(
                  localized.submit.capitalized,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.surface),
                ),
              ),
              // const Expanded(child: Text("heehe")),
              const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  void setArrivalDate(DateTime? newDate) {
    setState(() {
      arrivalDate = newDate?.add(const Duration(hours: 13));
    });
  }

  void setDapartureDate(DateTime? newDate) {
    setState(() {
      departureDate = newDate?.add(const Duration(hours: 11));
    });
  }
}
