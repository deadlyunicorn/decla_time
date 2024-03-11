import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/date_information_widget.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/reservation_details_container.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class TripLength extends StatelessWidget {
  const TripLength({
    required this.localized,
    required this.declaration,
    super.key,
  });

  final AppLocalizations localized;
  final Declaration declaration;

  @override
  Widget build(BuildContext context) {
    return OutlineContainer(
      child: DateInformationWidget<Declaration>(
        localized: localized,
        item: declaration,
        nights: declaration.nights,
      ),
    );
  }
}
