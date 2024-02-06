import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/route_outline.dart';
import 'package:decla_time/reservations_action_button_menu/getting_reservation_files_instructions/airbnb_file_instructions.dart';
import 'package:decla_time/reservations_action_button_menu/getting_reservation_files_instructions/booking_com_file_instructions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class GettingReservationFilesInstructionsRoute extends StatelessWidget {
  const GettingReservationFilesInstructionsRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final localized = AppLocalizations.of(context)!;

    return RouteOutline(
      title: localized.instructionsForFiles.capitalized,
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: const EdgeInsets.only( bottom: 64),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                AirbnbFileInstructions(
                  localized: localized,
                ),
                BookingComFileInstructions(
                  localized: localized,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
