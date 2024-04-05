import "dart:math";
import "package:decla_time/core/widgets/generic_calendar_grid_view/year/month/item/item_material_outline.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ItemsOfMonth<T> extends StatelessWidget {
  const ItemsOfMonth({
    required this.itemsOfMonth,
    required this.localized,
    required this.child,
    required this.gridDelegate,
    super.key, 
  });

  final List<T> itemsOfMonth;
  final AppLocalizations localized;
  final Widget Function(T) child;
  final SliverGridDelegate gridDelegate;

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding =
        min((MediaQuery.sizeOf(context).width ~/ 64), 36).toDouble();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      gridDelegate: gridDelegate,
      itemCount: itemsOfMonth.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ItemMaterialOutline<T>(
            item: itemsOfMonth[index],
            localized: localized,
            child: child,
          ),
        );
      },
    );
  }
}
