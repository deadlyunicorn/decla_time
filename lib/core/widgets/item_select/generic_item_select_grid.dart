
import "dart:math";

import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

class ItemsFoundList<T> extends StatefulWidget {
  const ItemsFoundList({
    required this.items,
    required this.removeFromItemsFoundSoFar,
    required this.localized,
    required this.positionedChildren,
    required this.selectedItemsHandler,
    required this.child,
    super.key,
  });

  final List<T> items;
  final void Function(Iterable<T>) removeFromItemsFoundSoFar;
  final AppLocalizations localized;
  final List<Widget> Function({
    required T item,
    required AppLocalizations localized,
  }) positionedChildren;

  final Widget Function({
    required Set<int> setOfIndicesOfSelectedItems,
  }) selectedItemsHandler;

  final Widget Function({
    required T item,
    required AppLocalizations localized,
    required bool isSelected,
  }) child;

  @override
  State<ItemsFoundList<T>> createState() => _ItemsFoundListState<T>();
}

class _ItemsFoundListState<T> extends State<ItemsFoundList<T>> {
  Set<int> setOfIndicesOfSelectedItems = <int>{};
  bool isHolding = false;
  Set<int>? lastSelectedItemsSnapshot;
  int? indexOfTheGridItemThatStartedTheHold;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return SizedBox(
        width: min(MediaQuery.sizeOf(context).width, kMaxWidthLargest),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                //DE/SELECT ALL Buttons
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  runAlignment: WrapAlignment.end,
                  verticalDirection: VerticalDirection.up,
                  runSpacing: 8,
                  spacing: 16,
                  children: <Widget>[
                    TextButton(
                      onPressed: unselectAll,
                      child: Text(widget.localized.clearSelection.capitalized),
                    ),
                    TextButton(
                      onPressed: selectAll,
                      child: Text(widget.localized.selectAll.capitalized),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              //Actual List
              child: GestureDetector(
                //used for keeping track of hold
                onHorizontalDragStart: startHolding,
                onHorizontalDragEnd: stopHolding,

                //TODO For Mobiles
                //! the handlers below are for mobile
                //! finish them at some point..
                /*
                    onTapDown: startHolding,
                    onTapUp: stopHolding,
                    onHorizontalDragUpdate: (details) {
                      print( details.localPosition );
                    },
                    onVerticalDragUpdate: (details) {
                      print( details.localPosition );
                    },
                        
                    */

                child: GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent:
                        kMaxContainerWidthSmall, //? Consider changing?
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: widget.items.length,
                  itemBuilder:
                      (BuildContext context, int indexOfCurrentGridItem) {
                    //TODO Mobiles
                    //!! Below might be useful
                    //!! when handling events from mobile
                    // print( context.findRenderObject() );

                    final T item = widget.items[indexOfCurrentGridItem];

                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            color: Theme.of(context).colorScheme.secondary,
                            child: InkWell(
                              onTap: () {
                                tapHandler(indexOfCurrentGridItem);
                              }, //needed for hover to work
                              onHover: (bool hovered) {
                                hoverHandler(indexOfCurrentGridItem);
                              },

                              child: widget.child(
                                isSelected:
                                    setOfIndicesOfSelectedItems.contains(
                                  indexOfCurrentGridItem,
                                ),
                                localized: widget.localized,
                                item: item,
                              ),
                            ),
                          ),
                        ),
                        ...widget.positionedChildren(
                          item: item,
                          localized: widget.localized,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            setOfIndicesOfSelectedItems.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: widget.selectedItemsHandler(
                      setOfIndicesOfSelectedItems: setOfIndicesOfSelectedItems,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      );
    }
  }

  void hoverHandler(int indexOfCurrentGridItem) {
    if (isHolding) {
      if (indexOfTheGridItemThatStartedTheHold == null) {
        indexOfTheGridItemThatStartedTheHold =
            indexOfCurrentGridItem; //keep track of where the hold started from.
        //keep track of the previously selected items.
        lastSelectedItemsSnapshot = setOfIndicesOfSelectedItems;
        //Started a new hold.
      } else {
        final int? indexOfGridItemThatStartedTheHoldUnmuttalbe =
            indexOfTheGridItemThatStartedTheHold;

        if (indexOfGridItemThatStartedTheHoldUnmuttalbe != null) {
          //Genearate a list from index that started
          //-> index we are currently at.
          Set<int> currentSelectionOfGridItems = <int>{
            ...List<int>.generate(
              //the items between started and currentlyHovered
              (indexOfGridItemThatStartedTheHoldUnmuttalbe -
                      indexOfCurrentGridItem)
                  .abs(),
              (int index) => (index +
                      min(
                        indexOfGridItemThatStartedTheHoldUnmuttalbe,
                        indexOfCurrentGridItem,
                      ))
                  .toInt(),
            ),
          };

          Set<int> finalSet = setOfIndicesOfSelectedItems = <int>{
            ...currentSelectionOfGridItems,
            ...?lastSelectedItemsSnapshot,
          };

          //! Remove the Union.
          finalSet.removeWhere(
            (int element) =>
                currentSelectionOfGridItems.contains(element) &&
                (lastSelectedItemsSnapshot?.contains(element) ?? false),
          );

          //! Minor adjustments for a smoother experience.
          //! ( First and last items of the colections )
          if (lastSelectedItemsSnapshot!.contains(
            indexOfGridItemThatStartedTheHoldUnmuttalbe,
          )) {
            finalSet.remove(indexOfGridItemThatStartedTheHoldUnmuttalbe);
          } else {
            finalSet.add(indexOfGridItemThatStartedTheHoldUnmuttalbe);
          }
          if (lastSelectedItemsSnapshot!.contains(
            indexOfCurrentGridItem,
          )) {
            finalSet.remove(indexOfCurrentGridItem);
          } else {
            finalSet.add(indexOfCurrentGridItem);
          }
          //! Minor adjustments for a smoother experience.
          //! ( First and last items of the colections )

          setState(() {
            setOfIndicesOfSelectedItems = finalSet;
          });
        }
      }
    }
  }

  void tapHandler(int listIndex) {
    return setState(() {
      if (setOfIndicesOfSelectedItems.contains(listIndex)) {
        setOfIndicesOfSelectedItems.remove(listIndex);
      } else {
        setOfIndicesOfSelectedItems.add(listIndex);
      }
    });
  }

  void stopHolding(DragEndDetails details) {
    setState(() {
      isHolding = false;
      indexOfTheGridItemThatStartedTheHold = null;
      lastSelectedItemsSnapshot = null;
    });
  }

  void startHolding(DragStartDetails details) {
    setState(() {
      isHolding = true;
    });
  }

  void selectAll() {
    setState(() {
      setOfIndicesOfSelectedItems = List<int>.generate(
        widget.items.length,
        (int index) => index,
      ).toSet();
    });
  }

  void unselectAll() {
    setState(() {
      setOfIndicesOfSelectedItems = <int>{};
    });
  }
}
