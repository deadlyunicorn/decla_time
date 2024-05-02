import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/translate_reservation_status.dart";
import "package:decla_time/declarations/utility/declaration_body.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/date_fields/date_pickers_field.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/id_field.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/listing_name_field.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/payout_field.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/platform_field.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/required_text_field.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/status_field.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/submit_button.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class ReservationForm extends StatefulWidget {
  const ReservationForm({
    required this.localized,
    required this.handleFormSubmit,
    super.key,
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController platformNameController = TextEditingController();
  final TextEditingController reservationPlaceController =
      TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController payoutController = TextEditingController();
  final TextEditingController reservationStatusController =
      TextEditingController();
  DateTime? arrivalDate;
  DateTime? departureDate;

  @override
  void initState() {
    super.initState();

    platformNameController.text = widget.platformName ?? "";
    reservationPlaceController.text = widget.listingName ?? "";
    idController.text = widget.id ?? "";
    guestNameController.text = widget.guestName ?? "";
    payoutController.text = widget.payout ?? "";
    reservationStatusController.text =
        widget.reservationStatus?.capitalized ?? "";
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
                children: <Widget>[
                  const SizedBox.square(
                    dimension: 16,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      PlatformField(
                        localized: widget.localized,
                        platformNameController: platformNameController,
                      ),
                      ReservationPlaceField(
                        localized: widget.localized,
                        listingNameController: reservationPlaceController,
                      ),
                      StatusField(
                        localized: widget.localized,
                        reservationStatusController:
                            reservationStatusController,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      runSpacing: 24,
                      spacing: 24,
                      children: <Widget>[
                        IdField(
                          hasInitialId: hasInitialId(),
                          idController: idController,
                          refresh: refresh,
                          localized: widget.localized,
                        ),
                        RequiredTextField(
                          submitFormHandler: submitReservationForm,
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
                  FutureBuilder<bool>(
                    future: idAlreadyExistsFuture(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      final bool reservationAlreadyRegistered =
                          snapshot.data ?? false;
                      return reservationAlreadyRegistered
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget
                                    .localized
                                    .willOverwriteExistingReservation
                                    .capitalized,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.amber),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SubmitButton(
                      submitReservationForm: submitReservationForm,
                      platformNameController: platformNameController,
                      listingNameController: reservationPlaceController,
                      idController: idController,
                      guestNameController: guestNameController,
                      payoutController: payoutController,
                      reservationStatusController: reservationStatusController,
                      arrivalDate: arrivalDate,
                      departureDate: departureDate,
                      handleFormSubmit: widget.handleFormSubmit,
                      localized: widget.localized,
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

  void submitReservationForm() {
    if (_formKey.currentState!.validate()) {
      final String bookingPlatform = platformNameController.text;
      final String listingName = reservationPlaceController.text;
      final String id = idController.text;
      final String guestName = guestNameController.text;
      final double payout = double.tryParse(payoutController.text)!;
      final String reservationStatus = translateReservationStatus(
        reservationStatusController.text,
        widget.localized,
      ).name;
      final DateTime arrivalDate = this.arrivalDate!;
      final DateTime departureDate = this.departureDate!;

      final Reservation reservation = Reservation(
        reservationPlaceId: -1, //TODO IMPLEMENT SOON.
        cancellationAmount: null, //TODO UNIMPLEMENTED
        cancellationDate: null, //TODO UNIMPLEMENTED
        bookingPlatform:
            DeclarationBody.extractBookingPlatform(bookingPlatform),
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
  }

  bool hasInitialId() {
    final String? initialId = widget.id;
    return (initialId != null && initialId.isNotEmpty);
  }

  Future<bool> idAlreadyExistsFuture() async {
    return await context
        .watch<IsarHelper>()
        .reservationActions
        .idAlreadyExists(idController.text);
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
