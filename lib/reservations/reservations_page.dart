import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservations_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservationsPage extends StatelessWidget {
  const ReservationsPage({
    super.key,
    required this.localized,
    required this.scrollController,
  });

  final AppLocalizations localized;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ReservationsList(
            reservations: snapshot.data ?? [],
            scrollController: scrollController,
            localized: localized,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
      future: context
          .watch<IsarHelper>()
          .reservationActions
          .getAllEntriesFromReservations(),
    );
  }
}
