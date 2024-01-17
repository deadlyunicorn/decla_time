import 'dart:math';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/decleration_status_dot.dart';
import 'package:decla_time/reservations/presentation/reservation_status_dot.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservation_details/date_information_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationDetailsContainer extends StatelessWidget {
  const ReservationDetailsContainer({
    super.key,
    required this.reservation,
  });

  final Reservation reservation;
  int get nights =>
      reservation.departureDate.difference(reservation.arrivalDate).inDays + 1;

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.bodyLarge,
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: 600,
        height: min(
          500,
          MediaQuery.sizeOf(context).height - 250,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlineContainer(
                    child: Column(
                      children: [
                        Wrap(
                          //Platform and ID
                          spacing: 24,
                          alignment: WrapAlignment.spaceAround,
                          children: [
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: "${localized.platform.capitalized}: ",
                                style: Theme.of(context).textTheme.bodyLarge,
                                children: [
                                  TextSpan(
                                    text: reservation.bookingPlatform,
                                    style:
                                        Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ],
                              ),
                            ),
                            Text("ID: ${reservation.id}"),
                          ],
                        ),
                        const SizedBox.square(dimension: 8),
                        SizedBox(
                          width: 300,
                          child: Text(
                            "${localized.guestName.capitalized}: ${reservation.guestName}",
                            style: Theme.of(context).textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox.square(dimension: 8),
                        Text(reservation.listingName != null
                            ? "${localized.at.capitalized} ${reservation.listingName}"
                            : ''),
                      ],
                    ),
                  ),
                  OutlineContainer(
                    child: Column(
                      children: [
                        Text(
                          "${reservation.payout} €",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(color: Colors.green.shade300),
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
                    child: DateInformationWidget(
                      reservation: reservation,
                      nights: nights,
                    ),
                  ),
                ],
              ),
              Positioned(
                right: -4,
                top: -4,
                child: ReservationStatusDot(
                  size: 16,
                  reservationStatusString: reservation.reservationStatus,
                ),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: DeclarationStatusDot(
                  size: 16,
                  isDeclared: reservation.isDeclared,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OutlineContainer extends StatelessWidget {
  const OutlineContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
