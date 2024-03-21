import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/core/widgets/details_route/delete_button.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/details_route/details/basic_details.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/details_route/details/payout.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/details_route/details/trip_length.dart";
import "package:decla_time/declarations/declarations_view/declaration_container/details_route/temporary_declaration_manipulation_buttons.dart";
import "package:decla_time/reservations/presentation/decleration_status_dot.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class MainContainer extends StatelessWidget {
  const MainContainer({
    required this.localized,
    required this.declaration,
    super.key,
  });

  final AppLocalizations localized;
  final Declaration declaration;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.bodyLarge,
      child: Stack(
        children: <Widget>[
          Container(
            clipBehavior: Clip.antiAlias,
            width: kMaxWidthMedium,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
              child: ColumnWithSpacings(
                spacing: 32,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  BasicDetails(
                    localized: localized,
                    declaration: declaration,
                  ),
                  Payout(declaration: declaration, localized: localized),
                  TripLength(
                    localized: localized,
                    declaration: declaration,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: DeclarationStatusDot(
              localized: localized,
              size: 24,
              declarationStatus: declaration.declarationStatus,
            ),
          ),
          if (declaration.declarationStatus == DeclarationStatus.temporary)
            Positioned(
              right: 4,
              top: 4,
              child: TemporaryDeclarationManipulationButtons(
                declaration: declaration,
                localized: localized,
              ),
            ),
          Positioned(
            left: 4,
            top: 4,
            child: Row(
              children: <Widget>[
                DeleteButton(
                  localized: localized,
                  size: 24,
                  tooltipMessage: localized.deleteDeclarationFromLocal.capitalized,
                  dialogBody: localized.declarationDelataionDialogBody,
                  dialogHeadline:
                      localized.deleteDeclarationDialogHeadline.capitalized,
                  deleteFunction: () async {
                    await context
                        .read<IsarHelper>()
                        .declarationActions
                        .removeFromDatabase(declaration.declarationDbId);
                  },
                ),
                Tooltip(
                  message: "Describe",
                  child: IconButton(onPressed: (){
                    print("todo: refresh individual declaration by declarationDbId");
                  }, icon: Icon(Icons.refresh)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
