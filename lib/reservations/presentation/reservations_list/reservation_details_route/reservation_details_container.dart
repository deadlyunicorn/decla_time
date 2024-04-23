import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/enums/declaration_status.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations/presentation/decleration_status_dot.dart";
import "package:decla_time/reservations/presentation/reservation_status_dot.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/date_information_widget.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/reservation_delete_button.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/reservation_edit_button.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ReservationDetailsContainer extends StatelessWidget {
  const ReservationDetailsContainer({
    required this.reservation,
    required this.localized,
    super.key,
  });

  final Reservation reservation;
  final AppLocalizations localized;

  int get nights =>
      reservation.departureDate.difference(reservation.arrivalDate).inDays + 1;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.bodyLarge,
      child: Stack(
        children: <Widget>[
          Container(
            clipBehavior: Clip.antiAlias,
            width: kMaxWidthMedium,
            height: kMaxWidthMedium - 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  OutlineContainer(
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
                                    text: reservation
                                        .bookingPlatform.name.capitalized,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: "ID: ",
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: reservation.id,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
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
                                "${localized.guestName.capitalized}: ",
                                style: Theme.of(context).textTheme.bodyLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                              ),
                              Flexible(
                                child: FittedBox(
                                  alignment: Alignment.center,
                                  child: Text(reservation.guestName),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox.square(dimension: 8),
                        (reservation.listingName != null &&
                                reservation.listingName!.isNotEmpty)
                            ? Text(
                                // ignore: lines_longer_than_80_chars
                                "${localized.at.capitalized} '${reservation.listingName}'",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  OutlineContainer(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "${reservation.payout.toStringAsFixed(2)} €",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                        Text(
                          "${(reservation.payout / nights).toStringAsFixed(2)} € / ${localized.night}",
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  OutlineContainer(
                    child: DateInformationWidget<Reservation>(
                      localized: localized,
                      item: reservation,
                      nights: nights,
                    ),
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
              declarationStatus: reservation.isDeclared
                  ? DeclarationStatus.finalized
                  : DeclarationStatus.undeclared,
            ),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: ReservationStatusDot(
              localized: localized,
              size: 24,
              reservationStatusString: reservation.reservationStatus,
            ),
          ),
          Positioned(
            right: 32,
            top: 4,
            child: ReservationEditButton(
              reservation: reservation,
              size: 24,
              localized: localized,
            ),
          ),
          Positioned(
            left: 4,
            top: 4,
            child: ReservationDeleteButton(
              localized: localized,
              reservationId: reservation.id,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class OutlineContainer extends StatelessWidget {
  const OutlineContainer({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
