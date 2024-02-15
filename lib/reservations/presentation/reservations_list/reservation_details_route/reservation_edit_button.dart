import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/reservations/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservation_details_route/reservation_editing_route.dart';

class ReservationEditButton extends StatelessWidget {
  const ReservationEditButton({
    super.key,
    required this.reservation,
    required this.size,
    required this.localized,
  });

  final Reservation reservation;
  final double size;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: localized.reservationEntryChange.capitalized,
      child: SizedBox(
        height: size,
        width: size,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ReservationEditingRoute(
                    localized: localized,
                    reservation: reservation,
                  );
                },
              ),
            );
          },
          child: const Icon(
            Icons.edit,
            size: 24,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
