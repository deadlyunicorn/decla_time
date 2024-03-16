import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/get_values_between_strings.dart";
import "package:decla_time/declarations/utility/declaration_body.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/post_new_declaration_request.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:http/http.dart";

class DeclarationSubmitController extends ChangeNotifier {
  List<Reservation> _reservationsPendingSubmission = <Reservation>[];
  final List<ReservationSubmitResult> _reservationsSubmitted =
      <ReservationSubmitResult>[];

  List<Reservation> get reservationsPendingSubmission =>
      _reservationsPendingSubmission;
  List<ReservationSubmitResult> get reservationsSubmitted =>
      _reservationsSubmitted;

  void setReservationsPendingSubmission(List<Reservation> reservations) {
    _reservationsPendingSubmission = reservations;
    notifyListeners();
  }

  //* Submit Operations

  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;
  void setSubmitStatus(bool newStatus) {
    _isSubmitting = newStatus;
    notifyListeners();
  }
  //? Submit Operations *//

  Future<void> startSubmitting({
    required List<Reservation> reservations,
    required DeclarationsPageHeaders headers,
    required String propertyId,
    //? Don't import searchPageData -
    //? you might get a bit faster for longer durations
    //? But if anything ever goes wrong it will be harder to debug.
  }) async {
    setReservationsPendingSubmission(reservations);
    setSubmitStatus(true);

    while (reservationsPendingSubmission.isNotEmpty) {
      final Reservation currentReservation =
          reservationsPendingSubmission.first;
      try {
        final DeclarationBody declarationBody = DeclarationBody(
          arrivalDate: currentReservation.arrivalDate,
          departureDate: currentReservation.departureDate,
          payout: currentReservation.payout,
          platform: currentReservation.bookingPlatform,
        );

        final Response declarationResponse = await Future.any(
          <Future<Response>>[
            postNewDeclarationRequest(
              headersObject: headers,
              newDeclarationBody: declarationBody,
              propertyId: propertyId,
            ),
            Future<void>.delayed(const Duration(minutes: 1, seconds: 30))
                .then((_) {
              throw TimedOutException();
            }),
          ],
        );

        final String infoMessage = getBetweenStrings(
          declarationResponse.body,
          'ui-messages-info-detail">',
          "</span>",
        );

        bool wasSuccessful = false;
        if (infoMessage == "Επιτυχής Αποθήκευση") {
          wasSuccessful = true;
        }

  //TODO if was successful, add locally the isDeclaredStatus and show an indicator when selecting for declaring. 


        _reservationsPendingSubmission.removeAt(0);
        _reservationsSubmitted.add(
          ReservationSubmitResult(
            reservation: currentReservation,
            wasSuccessful: wasSuccessful,
          ),
        );
      } catch (error) {
        _reservationsPendingSubmission.removeAt(0);
        _reservationsSubmitted.add(
          ReservationSubmitResult(
            reservation: currentReservation,
            wasSuccessful: false,
          ),
        );
      }
      notifyListeners();
    }

    setSubmitStatus(false);
  }
}

class ReservationSubmitResult {
  final Reservation reservation;
  final bool wasSuccessful;

  ReservationSubmitResult({
    required this.reservation,
    required this.wasSuccessful,
  });
}
