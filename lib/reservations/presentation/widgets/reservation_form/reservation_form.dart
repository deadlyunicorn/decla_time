import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/translate_reservation_status.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/id_field.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/date_fields/date_pickers_field.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/listing_name_field.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/payout_field.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/platform_field.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/required_text_field.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/status_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservationForm extends StatefulWidget {
  const ReservationForm({
    super.key,
    required this.localized,
    required this.handleFormSubmit,
    this.platformName,
    this.listingName,
    this.id,
    this.guestName,
    this.payout,
    this.reservationStatus,
    this.arrivalDate,
    this.departureDate,
  });

  final AppLocalizations localized;
  final void Function(Reservation reservation) handleFormSubmit;

  //? Below are default values -
  final String? platformName;
  final String? listingName;
  final String? id;
  final String? guestName;
  final String? payout;
  final String? reservationStatus;
  final DateTime? arrivalDate;
  final DateTime? departureDate;

  @override
  State<ReservationForm> createState() => _ReservationFormState();
}

class _ReservationFormState extends State<ReservationForm> {
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
  void initState() {
    super.initState();

    platformNameController.text = widget.platformName ?? "";
    listingNameController.text = widget.listingName ?? "";
    idController.text = widget.id ?? "";
    guestNameController.text = widget.guestName ?? "";
    payoutController.text = widget.payout ?? "";
    reservationStatusController.text = widget.reservationStatus != null
        ? translateReservationStatus(widget.reservationStatus ?? "").name
        : "";
    arrivalDate = widget.arrivalDate;
    departureDate = widget.departureDate;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                        localized: widget.localized,
                        platformNameController: platformNameController,
                      ),
                      ListingNameField(
                        localized: widget.localized,
                        listingNameController: listingNameController,
                      ),
                      StatusField(
                        localized: widget.localized,
                        reservationStatusController:
                            reservationStatusController,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all( 16 ),
                    child: Wrap(
                      runSpacing: 24,
                      spacing: 24,
                      children: [
                        IdField(
                          hasInitialId: hasInitialId(),
                          idController: idController,
                          refresh: refresh,
                          localized: widget.localized,
                        ),
                        RequiredTextField(
                          controller: guestNameController,
                          label: widget.localized.guestName.capitalized,
                          localized: widget.localized,
                        ),
                      ],
                    ),
                  ),
                  PayoutField(
                    payoutController: payoutController,
                    localized: widget.localized,
                  ),
                  DatePickersField(
                    departureDate: departureDate,
                    arrivalDate: arrivalDate,
                    localized: widget.localized,
                    setArrivalDate: setArrivalDate,
                    setDepartureDate: setDapartureDate,
                  ),
                  FutureBuilder(
                      future: idAlreadyExistsFuture(),
                      builder: (context, snapshot) {
                        final reservationAlreadyRegistered =
                            snapshot.data ?? false;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            reservationAlreadyRegistered
                                ? widget
                                    .localized
                                    .willOverwriteExistingReservation
                                    .capitalized
                                : "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.amber),
                          ),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
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

                          widget.handleFormSubmit(reservation);
                          Navigator.pop(context, reservation);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.localized.submit.capitalized,
                            style: Theme.of(context).textTheme.headlineLarge),
                      ),
                    ),
                  ),
                  // const Expanded(child: Text("heehe")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool hasInitialId() {
    final initialId = widget.id;
    return (initialId != null && initialId.isNotEmpty);
  }

  Future<bool> idAlreadyExistsFuture() async {
    return await context.read<IsarHelper>().idAlreadyExists(idController.text);
  }

  void refresh() {
    setState(() {});
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
