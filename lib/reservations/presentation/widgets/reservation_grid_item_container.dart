import 'package:decla_time/reservations/business/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationGridItemContainerItems extends StatelessWidget {
  const ReservationGridItemContainerItems({
    super.key,
    required this.reservation,
    required this.nights,
    required this.localized,
  });

  final Reservation reservation;
  final int nights;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            "${reservation.payout.toStringAsFixed(2)} €",
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
    );
  }
}
