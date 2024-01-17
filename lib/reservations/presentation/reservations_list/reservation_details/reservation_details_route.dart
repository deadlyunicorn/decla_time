import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservation_details/reservation_details_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class ReservationDetailsRoute extends StatelessWidget {
  const ReservationDetailsRoute({
    super.key,
    required this.reservation,
  });

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return RouteOutline(
      title: localized.details.capitalized,
      child: Column(
        children: [
          ReservationDetailsContainer(reservation: reservation),
          const SizedBox.square(dimension: 16),
          Text(
            formatLastEdit(reservation.lastEdit, localized: localized),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String formatLastEdit(DateTime? lastEdit,
      {required AppLocalizations localized}) {
    return lastEdit != null
        ? "${localized.lastEdit.capitalized}: ${DateFormat("dd/MM/y HH:mm").format(lastEdit)}"
        : "";
  }
}
