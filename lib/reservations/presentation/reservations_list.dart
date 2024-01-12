import 'dart:math';

import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservation_status_dot.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationsList extends StatelessWidget {
  const ReservationsList({super.key});

  static List<Reservation> mockReservations = [
    Reservation(
        bookingPlatform: "Airbnb",
        listingName: "Good Listing",
        id: "123 404",
        guestName: "John Doe",
        arrivalDate: DateTime(2022, 12, 12),
        departureDate: DateTime(2022, 12, 19),
        payout: 320,
        reservationStatus: "ok"),
    Reservation(
        bookingPlatform: "Airbnb",
        listingName: "Good Listing",
        id: "123 404",
        guestName: "John Doe",
        arrivalDate: DateTime(2022, 12, 12),
        departureDate: DateTime(2022, 12, 19),
        payout: 320,
        reservationStatus: "ok"),
    Reservation(
        bookingPlatform: "Airbnb",
        listingName: "Good Listing",
        id: "123 404",
        guestName: "John Doe",
        arrivalDate: DateTime(2022, 12, 12),
        departureDate: DateTime(2022, 12, 19),
        payout: 320,
        reservationStatus: "ok"),
    Reservation(
        bookingPlatform: "Airbnb",
        listingName: "Good Listing",
        id: "123 404",
        guestName: "John Hoe",
        arrivalDate: DateTime(2022, 09, 12),
        departureDate: DateTime(2022, 09, 19),
        payout: 320,
        reservationStatus: "ok"),
    Reservation(
        bookingPlatform: "Airbnb",
        listingName: "Good Listing",
        id: "123 404",
        guestName: "John Hoe",
        arrivalDate: DateTime(2022, 09, 12),
        departureDate: DateTime(2022, 09, 19),
        payout: 320,
        reservationStatus: "ok"),
    Reservation(
        bookingPlatform: "Airbnb",
        listingName: "Good Listing",
        id: "123 404",
        guestName: "John Hoe",
        arrivalDate: DateTime(2022, 09, 12),
        departureDate: DateTime(2022, 09, 19),
        payout: 320,
        reservationStatus: "ok"),
    Reservation(
        bookingPlatform: "Booking.com",
        listingName: "Okay Listing",
        id: "101 404",
        guestName: "John Shoe",
        arrivalDate: DateTime(2023, 11, 24),
        departureDate: DateTime(2023, 11, 30),
        payout: 170,
        reservationStatus: "cancelled"),
    Reservation(
        bookingPlatform: "Airrrr",
        listingName: "Okay Listing",
        id: "101 404",
        guestName: "Cool guy",
        arrivalDate: DateTime(2023, 11, 21),
        departureDate: DateTime(2023, 11, 22),
        payout: 170,
        reservationStatus: "312"),
  ];

  @override
  Widget build(BuildContext context) {
    Map<int, Map<int, List<Reservation>>> yearMonthMap =
        {}; //!This will be replaced by database actions

    mockReservations
      ..sort((a, b) => -a.departureDate.difference(b.departureDate).inDays)
      ..forEach((reservation) {
        yearMonthMap.addAll({
          reservation.departureDate.year: {
            ...yearMonthMap[reservation.arrivalDate.year] ?? {},
            reservation.departureDate.month: [
              ...?yearMonthMap[reservation.arrivalDate.year]
                  ?[reservation.arrivalDate.month],
              reservation
            ]
          }
        });
      });

    return Center(
      child: SizedBox(
        width: min(MediaQuery.sizeOf(context).width, 900),
        child: ListView.builder(
          itemCount: yearMonthMap.entries.length,
          itemBuilder: (context, index) {
            final int year = yearMonthMap.keys.toList()[index];

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$year",
                  style: Theme.of(context).textTheme.headlineLarge,

                ),
                ReservationsOfYear(
                  reservationsMapYear: yearMonthMap[year]!,
                  year: year,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ReservationsOfYear extends StatelessWidget {
  const ReservationsOfYear(
      {super.key, required this.reservationsMapYear, required this.year});

  final Map<int, List<Reservation>> reservationsMapYear;
  final int year;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding =
        min((MediaQuery.sizeOf(context).width ~/ 64), 36).toDouble();

    return ListView.builder(
        shrinkWrap: true,
        itemCount: reservationsMapYear.values.length,
        itemBuilder: (context, index) {
          int month = reservationsMapYear.keys.toList()[index];
          final reservationsOfMonth = reservationsMapYear[month]!;

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        DateFormat.MMMM("en-US").format(
                          DateTime(0, month),
                        ),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150.0,
                        crossAxisSpacing: horizontalPadding,
                      ),
                      itemCount:
                          reservationsMapYear.length * 2, //!TO BE CHANGED!!
                      itemBuilder: (context, index) {
                        final currentIndex =
                            index % 3; //!TO BE CHANGED TO INDEX

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Theme.of(context).colorScheme.secondary),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(reservationsOfMonth[currentIndex]
                                      .guestName),
                                  Text(
                                      "${reservationsOfMonth[currentIndex].payout} €"),
                                  Text(
                                      "${reservationsOfMonth[currentIndex].departureDate.difference(reservationsOfMonth[currentIndex].arrivalDate).inDays + 1} nights"),
                                  ReservationStatusDot(
                                      reservationStatusString:
                                          reservationsOfMonth[currentIndex]
                                              .reservationStatus)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
