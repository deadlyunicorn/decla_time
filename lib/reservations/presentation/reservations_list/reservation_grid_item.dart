import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservation_status_dot.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservation_details/reservation_details_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationGridItem extends StatelessWidget {
  const ReservationGridItem({
    super.key,
    required this.reservation,
  });

  final Reservation reservation;

  int get nights =>
      reservation.departureDate.difference(reservation.arrivalDate).inDays + 1;

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ReservationDetailsRoute(
                    reservation: reservation,
                  );
                },
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.secondary),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    reservation.guestName,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${reservation.payout}€",
                    style: Theme.of(context).textTheme.headlineSmall!,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  Text(
                    "$nights ${localized.nights}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: ReservationStatusDot(
            reservationStatusString: reservation.reservationStatus,
          ),
        ),
        Positioned(
          top: -16,
          left: 0,
          child: Text(
            DateFormat("dd").format(reservation.departureDate),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                fontSize: 16),
          ),
        ),
      ],
    );
  }
}
