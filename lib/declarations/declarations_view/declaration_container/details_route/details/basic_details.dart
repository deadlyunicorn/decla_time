import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/declarations/database/declaration.dart";
import "package:decla_time/reservations/presentation/reservations_list/reservation_details_route/reservation_details_container.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

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
