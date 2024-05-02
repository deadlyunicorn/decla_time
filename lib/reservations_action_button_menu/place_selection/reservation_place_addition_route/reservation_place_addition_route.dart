import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/custom_alert_dialog.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class ReservationPlaceAdditionRoute extends StatefulWidget {
  const ReservationPlaceAdditionRoute({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;
  @override
  State<ReservationPlaceAdditionRoute> createState() =>
      _ReservationPlaceAdditionRouteState();
}

class _ReservationPlaceAdditionRouteState
    extends State<ReservationPlaceAdditionRoute> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      confirmButtonAction: () async {
        final String friendlyName = textEditingController.text;
        if (friendlyName.isNotEmpty) {
          await context
              .read<IsarHelper>()
              .reservationPlaceActions
              .putReservationPlace(friendlyName);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      title: widget.localized.addPlaceForReservations.capitalized,
      localized: widget.localized,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${widget.localized.placeName.capitalized}: "),
            SizedBox(
              width: kFormFieldWidth,
              child: TextField(
                controller: textEditingController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
