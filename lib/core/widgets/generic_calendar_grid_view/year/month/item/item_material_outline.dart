import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ItemMaterialOutline<T> extends StatelessWidget {
  const ItemMaterialOutline({
    required this.item,
    required this.localized,
    required this.child,
    super.key,
  });

  final T item;
  final AppLocalizations localized;
  final Widget Function(T item) child;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.none,
      color: Theme.of(context).colorScheme.secondary,
      child: child(item),
    );
  }
}
