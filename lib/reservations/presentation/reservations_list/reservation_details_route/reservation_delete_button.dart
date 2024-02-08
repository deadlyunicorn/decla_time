import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ReservationDeleteButton extends StatelessWidget {
  const ReservationDeleteButton({
    super.key,
    required this.size,
    required this.localized,
    required this.reservationId,
  });

  final double size;
  final AppLocalizations localized;
  final String reservationId;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: localized.reservationEntryDelete.capitalized,
      child: SizedBox(
        height: size,
        width: size,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                localized: localized,
                confirmButtonAction: () {
                  context.read<IsarHelper>().removeFromDatabase(reservationId);
                  Navigator.popUntil(context, (route) {
                    return route.isFirst;
                  });
                },
                title: localized.reservationEntryDelete.capitalized,
                child: Text(
                  localized
                      .thisActionWillPermanentlyDeleteReservation.capitalized,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
          child: Icon(
            Icons.delete_forever_rounded,
            size: 24,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
