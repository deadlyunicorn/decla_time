import "package:decla_time/core/enums/declaration_type.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/date_information_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class FinalizedDeclarationDetailsSection extends StatelessWidget {
  const FinalizedDeclarationDetailsSection({
    required this.declarationDetails,
    required this.localized,
    super.key,
  });

  final FinalizedDeclarationDetails declarationDetails;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ColumnWithSpacings(
          spacing: 4,
          children: <Widget>[
            Text(
              // ignore: lines_longer_than_80_chars
              "${localized.declarationDate.capitalized}: ${DateInformationWidget.dateFormat(declarationDetails.declarationDate)}",
            ),
            Text(
              "${localized.declarationType.capitalized}: ${FinalizedDeclarationDetails.getDeclarationTypeLocalized(
                localized: localized,
                type: declarationDetails.declarationType,
              ).capitalized}",
            ),
            if (declarationDetails.declarationType == DeclarationType.amending)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("${localized.amendingFor.capitalized}:"),
                  TextButton(
                    onPressed: () {
                      print("take us to a route with the amending declaration");
                    },
                    child: Text(
                      "${localized.serialNumberShort}: ${declarationDetails.serialNumberOfAmendingDeclaration!}",
                    ),
                  ),
                ],
              ),
            Text(declarationDetails.declarationDbId.toString()),
          ],
        ),
      ),
    );
  }
}
