import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/enums/declaration_type.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:decla_time/reservations/presentation/decleration_status_dot.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/date_information_widget.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/reservation_details_container.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class DeclarationDetailsContainer extends StatelessWidget {
  const DeclarationDetailsContainer({
    required this.declaration,
    required this.declarationDetails,
    required this.localized,
    super.key,
  });

  final Declaration declaration;
  final FinalizedDeclarationDetails? declarationDetails;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MainContainer(localized: localized, declaration: declaration),
        if (declarationDetails != null)
          DeclarationDetails(
            declarationDetails: declarationDetails!,
            localized: localized,
          ),
      ],
    );
  }
}

class DeclarationDetails extends StatelessWidget {
  const DeclarationDetails({
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
              "${localized.declarationDate.capitalized}: ${DateInformationWidget.dateFormat(declarationDetails!.declarationDate)}",
            ),
            Text(
              "Type: ${declarationDetails.declarationType.name}",
            ), //TODO Add translation - localized
            if (declarationDetails.declarationType == DeclarationType.amending)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Amending For Localized:"),
                  TextButton(
                    onPressed: () {
                      print("take us to a route with the amending declaration");
                    },
                    child: Text(
                      "${localized.serialNumberShort}: ${declarationDetails.serialNumberOfAmendingDeclaration!}",
                    ),
                  )
                ],
              ),
            Text(declarationDetails.declarationDbId.toString()),
          ],
        ),
      ),
    );
  }
}

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
          // Positioned(
          //   right: 4,
          //   top: 4,
          //   child: ReservationStatusDot(
          //     localized: localized,
          //     size: 24,
          //     reservationStatusString: reservation.reservationStatus,
          //   ),
          // ),
          // Positioned( TODO Declaration Edit Button
          //   right: 32,
          //   top: 4,
          //   child: ReservationEditButton(
          //     reservation: reservation,
          //     size: 24,
          //     localized: localized,
          //   ),
          // ),

          //     Positioned( //TODO remove the delcaration from locally
          //       left: 4,
          //       top: 4,
          //       child: ReservationDeleteButton(
          //         localized: localized,
          //         reservationId: reservation.id,
          //         size: 24,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class BasicDetails extends StatelessWidget {
  const BasicDetails({
    required this.localized,
    required this.declaration,
    super.key,
  });

  final AppLocalizations localized;
  final Declaration declaration;

  @override
  Widget build(BuildContext context) {
    return OutlineContainer(
      child: Column(
        children: <Widget>[
          Wrap(
            //Platform and ID
            spacing: 24,
            alignment: WrapAlignment.spaceAround,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: "${localized.platform.capitalized}: ",
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: <InlineSpan>[
                    TextSpan(
                      text: declaration.bookingPlatform.name.capitalized,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              ),
              if (declaration.serialNumber != null)
                RichText(
                  text: TextSpan(
                    text: "${localized.serialNumberShort}: ",
                    children: <InlineSpan>[
                      TextSpan(
                        text: "${declaration.serialNumber}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox.square(dimension: 8),
          SizedBox(
            width: kMaxWidthSmall - 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${localized.declaration_status.capitalized}: ",
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                Flexible(
                  child: FittedBox(
                    alignment: Alignment.center,
                    child: Text(
                      Declaration.getLocalizedDeclarationStatus(
                        localized: localized,
                        declarationStatus: declaration.declarationStatus,
                      ).capitalized,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox.square(dimension: 8),
          (
                  //TODO Friendly Name.
                  declaration.propertyId != null &&
                      declaration.propertyId!.isNotEmpty)
              ? Text(
                  // ignore: lines_longer_than_80_chars
                  "${localized.at.capitalized} '${declaration.propertyId}'",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

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

class Payout extends StatelessWidget {
  const Payout({
    required this.declaration,
    required this.localized,
    super.key,
  });

  final Declaration declaration;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        OutlineContainer(
          child: Column(
            children: <Widget>[
              Text(
                // ignore: lines_longer_than_80_chars
                "${(declaration.cancellationAmount ?? declaration.payout).toStringAsFixed(2)} €",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              Text(
                "${((declaration.cancellationAmount ?? declaration.payout) / declaration.nights).toStringAsFixed(2)} € / ${localized.night}",
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        ),if (declaration.cancellationAmount != null)
            Positioned(
              top: -16,
              left: -32,
              child: Transform.rotate(
                angle: -0.24,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(localized.cancelled.capitalized,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!), //TODO CHECK how it looks
                ),
              ),
            ),
        
      ],
    );
  }
}
