import "package:decla_time/declarations/database/finalized_declaration_details.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter/material.dart";

class DeclarationDetailsContainer extends StatelessWidget {
  const DeclarationDetailsContainer({
    required this.declarationDetails,
    required this.localized,
    super.key,
  });

  final FinalizedDeclarationDetails declarationDetails;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: Theme.of(context).textTheme.bodyLarge,
      child: const Stack(
        children: <Widget>[
          // Container(
          //   clipBehavior: Clip.antiAlias,
          //   width: kMaxWidthMedium,
          //   height: kMaxWidthMedium - 96,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8),
          //     color: Theme.of(context).colorScheme.secondary,
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: <Widget>[
          //         OutlineContainer(
          //           child: Column(
          //             children: <Widget>[
          //               Wrap(
          //                 //Platform and ID
          //                 spacing: 24,
          //                 alignment: WrapAlignment.spaceAround,
          //                 crossAxisAlignment: WrapCrossAlignment.center,
          //                 children: <Widget>[
          //                   RichText(
          //                     maxLines: 1,
          //                     overflow: TextOverflow.ellipsis,
          //                     text: TextSpan(
          //                       text: "${localized.platform.capitalized}: ",
          //                       style: Theme.of(context).textTheme.bodyLarge,
          //                       children: <InlineSpan>[
          //                         TextSpan(
          //                           text: reservation.bookingPlatform,
          //                           style: Theme.of(context)
          //                               .textTheme
          //                               .headlineSmall,
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   RichText(
          //                     text: TextSpan(
          //                       text: "ID: ",
          //                       children: <InlineSpan>[
          //                         TextSpan(
          //                           text: reservation.id,
          //                           style: Theme.of(context)
          //                               .textTheme
          //                               .headlineSmall,
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               const SizedBox.square(dimension: 8),
          //               SizedBox(
          //                 width: kMaxWidthSmall - 80,
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: <Widget>[
          //                     Text(
          //                       "${localized.guestName.capitalized}: ",
          //                       style: Theme.of(context).textTheme.bodyLarge,
          //                       overflow: TextOverflow.ellipsis,
          //                       maxLines: 1,
          //                       textAlign: TextAlign.center,
          //                     ),
          //                     Flexible(
          //                       child: FittedBox(
          //                         alignment: Alignment.center,
          //                         child: Text(reservation.guestName),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               const SizedBox.square(dimension: 8),
          //               (reservation.listingName != null &&
          //                       reservation.listingName!.isNotEmpty)
          //                   ? Text(
          //                       // ignore: lines_longer_than_80_chars
          //                       "${localized.at.capitalized} '${reservation.listingName}'",
          //                       textAlign: TextAlign.center,
          //                       maxLines: 2,
          //                       overflow: TextOverflow.ellipsis,
          //                     )
          //                   : const SizedBox.shrink(),
          //             ],
          //           ),
          //         ),
          //         OutlineContainer(
          //           child: Column(
          //             children: <Widget>[
          //               Text(
          //                 "${reservation.payout.toStringAsFixed(2)} €",
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .headlineMedium
          //                     ?.copyWith(
          //                       color: Theme.of(context).colorScheme.surface,
          //                     ),
          //                 maxLines: 1,
          //                 textAlign: TextAlign.center,
          //                 overflow: TextOverflow.ellipsis,
          //                 softWrap: true,
          //               ),
          //               Text(
          //                 "${(reservation.payout / nights).toStringAsFixed(2)} € / ${localized.night}",
          //                 style: Theme.of(context).textTheme.bodyMedium,
          //                 maxLines: 1,
          //                 textAlign: TextAlign.center,
          //                 overflow: TextOverflow.ellipsis,
          //                 softWrap: true,
          //               ),
          //             ],
          //           ),
          //         ),
          //         OutlineContainer(
          //           child: DateInformationWidget(
          //             localized: localized,
          //             reservation: reservation,
          //             nights: nights,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Positioned(
          //   right: 4,
          //   bottom: 4,
          //   child: DeclarationStatusDot(
          //     localized: localized,
          //     size: 24,
          //     declarationStatus: reservation.isDeclared
          //         ? DeclarationStatus.finalized
          //         : DeclarationStatus.undeclared,
          //   ),
          // ),
          // Positioned(
          //   right: 4,
          //   top: 4,
          //   child: ReservationStatusDot(
          //     localized: localized,
          //     size: 24,
          //     reservationStatusString: reservation.reservationStatus,
          //   ),
          // ),
          // Positioned(
          //   right: 32,
          //   top: 4,
          //   child: ReservationEditButton(
          //     reservation: reservation,
          //     size: 24,
          //     localized: localized,
          //   ),
          // ),
          // Positioned(
          //   left: 4,
          //   top: 4,
          //   child: ReservationDeleteButton(
          //     localized: localized,
          //     reservationId: reservation.id,
          //     size: 24,
          //   ),
          // ),
        ],
      ),
    );
  }
}
