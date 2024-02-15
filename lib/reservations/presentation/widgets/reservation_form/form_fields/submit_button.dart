import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/translate_reservation_status.dart';
import 'package:decla_time/reservations/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.platformNameController,
    required this.listingNameController,
    required this.idController,
    required this.guestNameController,
    required this.payoutController,
    required this.reservationStatusController,
    required this.arrivalDate,
    required this.departureDate,
    required this.handleFormSubmit,
    required this.localized,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController platformNameController;
  final TextEditingController listingNameController;
  final TextEditingController idController;
  final TextEditingController guestNameController;
  final TextEditingController payoutController;
  final TextEditingController reservationStatusController;
  final DateTime? arrivalDate;
  final DateTime? departureDate;
  final void Function(Reservation reservation) handleFormSubmit;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          final bookingPlatform = platformNameController.text;
          final listingName = listingNameController.text;
          final id = idController.text;
          final guestName = guestNameController.text;
          final payout = double.tryParse(payoutController.text)!;
          final reservationStatus = translateReservationStatus(reservationStatusController.text, localized).name;
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

          handleFormSubmit(reservation);
          Navigator.pop(context, reservation);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          localized.submit.capitalized,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
