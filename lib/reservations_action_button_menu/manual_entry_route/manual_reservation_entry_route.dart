import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/fasthash.dart';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/date_fields/date_pickers_field.dart';
import 'package:decla_time/reservations_action_button_menu/manual_entry_route/form_fields/required_text_field.dart';
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
  final platformNameController = TextEditingController();
  final listingNameController = TextEditingController();
  final idController = TextEditingController();
  final guestNameController = TextEditingController();
  final payoutController = TextEditingController();
  final reservationStatusController = TextEditingController();
  DateTime? arrivalDate;
  DateTime? departureDate;

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return RouteOutline(
      title: localized.manualAddition.capitalized,
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: kMaxWidthLargest,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
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
                          reservationStatusController:
                              reservationStatusController,
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        SizedBox(
                          width: kMaxContainerWidthSmall * 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32),
                                child: IconButton(
                                  onPressed: () {
                                    idController.text =
                                        fastHash(DateTime.now().toString())
                                            .abs()
                                            .toRadixString(16)
                                            .substring(0, 10);
                                  },
                                  icon: const Icon(Icons.shuffle_rounded),
                                ),
                              ),
                              Flexible(
                                child: RequiredTextField(
                                  controller: idController,
                                  label: "ID",
                                  localized: localized,
                                ),
                              ),
                            ],
                          ),
                        ),
                        RequiredTextField(
                          controller: guestNameController,
                          label: localized.guestName.capitalized,
                          localized: localized,
                        ),
                      ],
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
                        if (_formKey.currentState!.validate()) {
                          final bookingPlatform = platformNameController.text;
                          final listingName = listingNameController.text;
                          final id = idController.text;
                          final guestName = guestNameController.text;
                          final payout =
                              double.tryParse(payoutController.text)!;
                          final reservationStatus =
                              reservationStatusController.text;
                          final arrivalDate = this.arrivalDate!;
                          final departureDate = this.departureDate!;

                          final reservation = Reservation(
                            bookingPlatform: bookingPlatform,
                            listingName: listingName,
                            id: id,
                            guestName: guestName,
                            arrivalDate: arrivalDate,
                            departureDate: departureDate,
                            payout: payout,
                            reservationStatus: reservationStatus,
                          );

                          widget.addToReservationsFoundSoFar([reservation]);

                          Navigator.pop(context, reservation);
                        }
                      },
                      child: Text(
                        localized.submit.capitalized,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                    // const Expanded(child: Text("heehe")),
                  ],
                ),
              ),
            ),
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
