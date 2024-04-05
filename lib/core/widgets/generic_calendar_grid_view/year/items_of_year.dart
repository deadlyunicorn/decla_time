import "package:decla_time/core/widgets/generic_calendar_grid_view/year/month/items_of_month.dart";
import "package:decla_time/settings.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";

class ItemsOfYear<T> extends StatelessWidget {
  const ItemsOfYear({
    required this.itemsMapYear,
    required this.localized,
    required this.child,
    required this.gridDelegate,
    super.key,
  });

  final Map<int, List<T>> itemsMapYear;
  final AppLocalizations localized;
  final Widget Function(T) child;
  final SliverGridDelegate gridDelegate;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // A list where entries are separated by month.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemsMapYear.values.length,
      itemBuilder: (BuildContext context, int index) {
        int month = itemsMapYear.keys.toList()[index];
        final List<T> itemsOfMonth = itemsMapYear[month]!;

        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Column(
                children: <Widget>[
                  Padding(
                    //Month in local format.
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      DateFormat.MMMM(
                        context.watch<SettingsController>().locale,
                      ).format(
                        DateTime(0, month),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  ItemsOfMonth<T>(
                    gridDelegate: gridDelegate,
                    itemsOfMonth: itemsOfMonth,
                    localized: localized,
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
