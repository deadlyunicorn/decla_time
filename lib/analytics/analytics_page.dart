import "package:decla_time/analytics/app_settings.dart";
import "package:decla_time/analytics/graphs/analytics_graphs.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/declarations_action_button_menu/filtering_reservations/reservation_place_selector.dart";
import "package:decla_time/reservations/reservation_place.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  ReservationPlace? selectedReservationPlace;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: ColumnWithSpacings(
          spacing: 64,
          children: <Widget>[
            Text(
              widget.localized.analytics.capitalized,
              style: Theme.of(context).textTheme.headlineLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            ColumnWithSpacings(
              spacing: 8,
              children: <Widget>[
                Center(
                  child: ColumnWithSpacings(
                    spacing: 16,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${widget.localized.displayAnalyticsFor.capitalized}:",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      ReservationPlaceSelector(
                        setSelectedReservationPlace:
                            setSelectedReservationPlace,
                        selectedReservationPlace: selectedReservationPlace,
                        localized: widget.localized,
                      ),
                    ],
                  ),
                ),
                AnalyticsGraphs(
                  localized: widget.localized,
                  selectedReservationPlace: selectedReservationPlace,
                ),
              ],
            ),
            AppSettings(localized: widget.localized),
          ],
        ),
      ),
    );
  }

  void setSelectedReservationPlace(ReservationPlace? newPlace) {
    if (newPlace != selectedReservationPlace) {
      setState(() {
        selectedReservationPlace = newPlace;
      });
    }
  }
}
