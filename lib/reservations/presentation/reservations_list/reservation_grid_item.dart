import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservation_status_dot.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservation_details_route/reservation_details_route.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_grid_item_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationGridItem extends StatelessWidget {
  const ReservationGridItem({
    super.key,
    required this.reservation,
  });

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.none,
      color: Theme.of(context).colorScheme.secondary,
      child: Stack(
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
                      initialReservation: reservation,
                    );
                  },
                ),
              );
            },
            child: ReservationGridItemContainerItems(
              reservation: reservation,
              localized: localized,
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
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
