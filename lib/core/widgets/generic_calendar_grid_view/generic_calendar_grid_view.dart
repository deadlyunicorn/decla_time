import "dart:math";

import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/widgets/generic_calendar_grid_view/year/items_of_year.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

abstract class ItemWithDates {
  const ItemWithDates({
    required this.arrivalDate,
    required this.departureDate,
  });

  final DateTime arrivalDate;
  final DateTime departureDate;
}

class GenericCalendarGridView<T extends ItemWithDates> extends StatelessWidget {
  const GenericCalendarGridView({
    required this.items,
    required this.localized,
    required this.scrollController,
    required this.child,
    super.key,
  });

  final List<T> items;
  final AppLocalizations localized;
  final ScrollController scrollController;
  final Widget Function(T) child;

  @override
  Widget build(BuildContext context) {
    final Map<int, Map<int, List<T>>> yearMonthMap =
        genereateYearMonthMap(items);

    if (items.isNotEmpty) {
      return ListView.builder(
        controller: scrollController,
        // A list where entries are separated by year.
        itemCount: yearMonthMap.entries.length,
        itemBuilder: (BuildContext context, int index) {
          final int year = yearMonthMap.keys.toList()[index];

          return Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox.square(dimension: 32),
              Text(
                "$year",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                width: min(MediaQuery.sizeOf(context).width, kMaxWidthLargest),
                child: ItemsOfYear<T>(
                  child: child,
                  localized: localized,
                  itemsMapYear: yearMonthMap[year]!,
                ),
              ),
            ],
          );
        },
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "localized.itemsNotFoundLocally.capitalized".toString(), //TODO: FIX
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Map<int, Map<int, List<T>>> genereateYearMonthMap(
    List<T> items,
  ) {
    Map<int, Map<int, List<T>>> tempMap = <int, Map<int, List<T>>>{};

    for (final T item in items) {
      final int yearOfItem = item.departureDate.year;
      final int monthOfItem = item.departureDate.month;
      final List<T> existingReservationsOfTheMonth =
          tempMap[yearOfItem]?[monthOfItem] ?? <T>[];

      tempMap.addAll(<int, Map<int, List<T>>>{
        yearOfItem: <int, List<T>>{
          ...(tempMap[yearOfItem] ??
              <int, List<T>>{}), //The already existing or a new year map
          monthOfItem: <T>[
            ...existingReservationsOfTheMonth,
            item,
          ],
        },
      });
    }

    return tempMap;
  }
}
