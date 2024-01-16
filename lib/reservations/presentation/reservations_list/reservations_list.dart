import 'dart:math';

import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/reservations_list/reservations_of_year_list.dart';
import 'package:flutter/material.dart';

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
        lastEdit: DateTime(2023, 12, 1),
        payout: 320,
        reservationStatus: "ok"),
    Reservation(
        bookingPlatform: "Airbnb",
        listingName: "Good Listing",
        id: "123 404",
        lastEdit: DateTime(2023, 12, 1),
        guestName: "John Hoe",
        arrivalDate: DateTime(2022, 09, 12),
        departureDate: DateTime(2022, 09, 19),
        payout: 320,
        reservationStatus: "ok"),
    Reservation(
        bookingPlatform: "Booking.com",
        listingName: "Okay Listing",
        id: "101 404",
        guestName: "John Shoe of 2 and three and foour and fuiice",
        lastEdit: DateTime(2023, 2, 1),
        arrivalDate: DateTime(2023, 11, 24, 13),
        departureDate: DateTime(2023, 11, 30, 11),
        payout: 2723.48,
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
          // A list where entries are separated by year.
          itemCount: yearMonthMap.entries.length,
          itemBuilder: (context, index) {
            final int year = yearMonthMap.keys.toList()[index];

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.square( dimension: 32),
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
