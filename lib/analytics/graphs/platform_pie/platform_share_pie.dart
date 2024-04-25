import "package:decla_time/core/enums/booking_platform.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/plurals.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class PlatformSharePie extends StatelessWidget {
  const PlatformSharePie({
    required this.localized,
    required this.reservations,
    super.key,
  });

  final AppLocalizations localized;
  final List<Reservation> reservations;
  final int graphSize = 160;

  @override
  Widget build(BuildContext context) {
    return ColumnWithSpacings(
      spacing: 16,
      children: <Widget>[
        Text(
          localized.reservationsByPlatform.capitalized,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: graphSize * 2,
          child: SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            physics: MediaQuery.sizeOf(context).width > graphSize * 3
                ? const NeverScrollableScrollPhysics()
                : null,
            child: PlatformPie(
              localized: localized,
              size: graphSize.toDouble(),
              platformDetailsList: generatePlatformDetails(reservations),
            ),
          ),
        ),
      ],
    );
  }

  List<PlatformDetails> generatePlatformDetails(
    List<Reservation> reservations,
  ) {
    final List<PlatformDetails> platformList = <PlatformDetails>[];

    for (final Reservation reservation in reservations) {
      PlatformDetails? currentPlatform = platformList
          .where(
            (PlatformDetails e) => e.platform == reservation.bookingPlatform,
          )
          .firstOrNull;

      if (currentPlatform == null) {
        platformList.add(
          PlatformDetails(
            platform: reservation.bookingPlatform,
            reservationCount: 0,
            totalNights: 0,
            totalPayout: 0,
          ),
        );

        currentPlatform = platformList
            .where(
              (PlatformDetails e) => e.platform == reservation.bookingPlatform,
            )
            .first;
      }
      currentPlatform.reservationCount += 1;
      currentPlatform.totalNights += reservation.nights;
      currentPlatform.totalPayout +=
          reservation.cancellationAmount ?? reservation.payout;
    }

    return platformList;
  }

  static Color getPlatformColor(BookingPlatform platform) {
    switch (platform) {
      case BookingPlatform.airbnb:
        return Colors.red;
      case BookingPlatform.booking:
        return Colors.blue;
      case BookingPlatform.apartments:
        return Colors.brown;
      case BookingPlatform.clickstay:
        return Colors.orange;
      case BookingPlatform.homeaway:
        return Colors.indigo;
      case BookingPlatform.homestay:
        return Colors.lime;
      case BookingPlatform.luxury:
        return Colors.teal;
      case BookingPlatform.tripadvisor:
        return Colors.green;
      case BookingPlatform.other:
        return Colors.grey;
    }
  }
}

class PlatformPie extends StatefulWidget {
  const PlatformPie({
    required this.localized,
    required this.platformDetailsList,
    required this.size,
    super.key,
  });

  final AppLocalizations localized;
  final List<PlatformDetails> platformDetailsList;
  final double size;
  final TextStyle badgeTextStyle = const TextStyle(
    shadows: <Shadow>[
      Shadow(
        color: Colors.black,
        blurRadius: 1,
        offset: Offset(-1, 1),
      ),
    ],
  );

  @override
  State<PlatformPie> createState() => _PlatformPieState();
}

class _PlatformPieState extends State<PlatformPie> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: ColumnWithSpacings(
        mainAxisSize: MainAxisSize.min,
        spacing: 32,
        children: <Widget>[
          SizedBox(
            width: widget.size * 3 + 16,
            height: widget.size + 16,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        enabled: false,
                        touchCallback: (
                          FlTouchEvent event,
                          PieTouchResponse? pieTouchResponse,
                        ) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      centerSpaceRadius: (widget.size - 16) / 2,
                      sections: getSections(),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Text>[
                        Text(widget.localized.platforms.capitalized),
                        Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          "${widget.localized.reservations.capitalized}: " +
                              widget.platformDetailsList
                                  .fold(
                                    0,
                                    (
                                      int previousValue,
                                      PlatformDetails platformDetails,
                                    ) =>
                                        previousValue +
                                        platformDetails.reservationCount,
                                  )
                                  .toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getSections() => List<PieChartSectionData>.generate(
        widget.platformDetailsList.length,
        (int i) {
          final PlatformDetails currentPlatformDetails =
              widget.platformDetailsList[i];
          final bool isTouched = i == touchedIndex;
          final double radius =
              isTouched ? widget.size / 12 + 4 : widget.size / 12;
          final double fontSize = isTouched ? 20 : 16;
          final Color platformColor = PlatformSharePie.getPlatformColor(
            currentPlatformDetails.platform,
          );

          return PieChartSectionData(
            color: platformColor,
            showTitle: false,
            badgePositionPercentageOffset: 4,
            badgeWidget: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.background,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ColumnWithSpacings(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Text>[
                        Text(
                          // ignore: prefer_interpolation_to_compose_strings, lines_longer_than_80_chars
                          currentPlatformDetails.platform.name.capitalized,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: platformColor,
                          ),
                        ),
                        Text(
                          reservationOrReservations(
                            widget.localized,
                            currentPlatformDetails.reservationCount,
                          ),
                        ),
                      ],
                    ),
                    if (isTouched)
                      Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        "\n${widget.localized.total.capitalized}: "
                                // ignore: lines_longer_than_80_chars
                                "${currentPlatformDetails.totalPayout.toStringAsFixed(2)}"
                                " EUR\n" +
                            nightOrNights(
                              widget.localized,
                              currentPlatformDetails.totalNights,
                            ),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ),
            value: currentPlatformDetails.reservationCount.toDouble(),
            radius: radius,
            titlePositionPercentageOffset: 5,
            titleStyle: widget.badgeTextStyle.merge(
              TextStyle(
                fontSize: fontSize,
              ),
            ),
          );
        },
      );
}

class PlatformDetails {
  final BookingPlatform platform;
  int reservationCount;
  int totalNights;
  double totalPayout;

  PlatformDetails({
    required this.platform,
    required this.reservationCount,
    required this.totalNights,
    required this.totalPayout,
  });
}
