import 'dart:math';

import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_grid_item_container.dart';
import 'package:decla_time/reservations_action_button_menu/entries_found/is_selected_underline.dart';
import 'package:decla_time/reservations_action_button_menu/entries_found/reservation_details_tooltip.dart';
import 'package:decla_time/reservations_action_button_menu/entries_found/will_overwrite_tooltip.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ReservationsFoundList extends StatefulWidget {
  const ReservationsFoundList({
    super.key,
    required this.reservations,
    required this.removeFromReservationsFoundSoFar,
    required this.localized,
  });

  final List<Reservation> reservations;
  final void Function(Iterable<Reservation>) removeFromReservationsFoundSoFar;
  final AppLocalizations localized;

  @override
  State<ReservationsFoundList> createState() => _ReservationsFoundListState();
}

class _ReservationsFoundListState extends State<ReservationsFoundList> {
  Set<int> setOfIndicesOfSelectedReservations = {};

  bool isHolding = false;
  Set<int>? lastSelectedReservationsSnapshot;
  int? indexOfTheGridItemThatStartedTheHold;

  @override
  Widget build(BuildContext context) {
    if (widget.reservations.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return FutureBuilder(
          future:
              context.watch<IsarHelper>().filterRegistered(widget.reservations),
          builder: (context, snapshot) {
            final alreadyExistingReservationIds = (snapshot.data ?? []).map(
              (databaseNonNullReservations) => databaseNonNullReservations.id,
            );

            return SizedBox(
              width: min(MediaQuery.sizeOf(context).width, kMaxWidthLargest),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
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
                        children: [
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
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              kMaxContainerWidthSmall, //? Consider changing?
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: widget.reservations.length,
                        itemBuilder: (context, indexOfCurrentGridItem) {
                          //TODO Mobiles
                          //!! Below might be useful
                          //!! when handling events from mobile
                          // print( context.findRenderObject() );

                          final reservation =
                              widget.reservations[indexOfCurrentGridItem];

                          return Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  child: InkWell(
                                    onTap: () {
                                      tapHandler(indexOfCurrentGridItem);
                                    }, //needed for hover to work
                                    onHover: (hovered) {
                                      hoverHandler(indexOfCurrentGridItem);
                                    },
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Positioned(
                                          child:
                                              ReservationGridItemContainerItems(
                                            //Items.
                                            localized: widget.localized,
                                            reservation: reservation,
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: IsSelectedUnderline(
                                              isSelected:
                                                  setOfIndicesOfSelectedReservations
                                                      .contains(
                                                          indexOfCurrentGridItem)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ReservationDetailsTooltip(
                                reservation: reservation,
                                localized: widget.localized,
                              ),
                              WillOverwriteTooltip(
                                reservationAlreadyInDatabase:
                                    alreadyExistingReservationIds
                                        .contains(reservation.id),
                                localized: widget.localized,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  setOfIndicesOfSelectedReservations.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextButton(
                            //Submit button
                            //Submit Button
                            onPressed: () async {
                              await context
                                  .read<IsarHelper>()
                                  .insertMultipleEntriesToDb(
                                      setOfIndicesOfSelectedReservations
                                          .map((index) =>
                                              widget.reservations[index])
                                          .toList());
                              widget.removeFromReservationsFoundSoFar(
                                setOfIndicesOfSelectedReservations
                                    .map((index) => widget.reservations[index]),
                              );
                              setOfIndicesOfSelectedReservations.clear();
                            },
                            child: Text(
                              "${widget.localized.addSelected.capitalized} (${setOfIndicesOfSelectedReservations.length})",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            );
          });
    }
  }

  void hoverHandler(int indexOfCurrentGridItem) {
    if (isHolding) {
      if (indexOfTheGridItemThatStartedTheHold == null) {
        indexOfTheGridItemThatStartedTheHold =
            indexOfCurrentGridItem; //keep track of where the hold started from.
        lastSelectedReservationsSnapshot = //keep track of the previously selected items.
            setOfIndicesOfSelectedReservations;
        //Started a new hold.
      } else {
        final indexOfGridItemThatStartedTheHoldUnmuttalbe =
            indexOfTheGridItemThatStartedTheHold;

        if (indexOfGridItemThatStartedTheHoldUnmuttalbe != null) {
          //Genearate a list from index that started -> index we are currently at.
          Set<int> currentSelectionOfGridItems = {
            ...List.generate(
              //the items between started and currentlyHovered
              (indexOfGridItemThatStartedTheHoldUnmuttalbe -
                      indexOfCurrentGridItem)
                  .abs(),
              (index) => (index +
                      min(
                        indexOfGridItemThatStartedTheHoldUnmuttalbe,
                        indexOfCurrentGridItem,
                      ))
                  .toInt(),
            )
          };

          Set<int> finalSet = setOfIndicesOfSelectedReservations = {
            ...currentSelectionOfGridItems,
            ...?lastSelectedReservationsSnapshot
          };

          //! Remove the Union.
          finalSet.removeWhere((element) =>
              currentSelectionOfGridItems.contains(element) &&
              (lastSelectedReservationsSnapshot?.contains(element) ?? false));

          //! Minor adjustments for a smoother experience.
          //! ( First and last items of the colections )
          if (lastSelectedReservationsSnapshot!.contains(
            indexOfGridItemThatStartedTheHoldUnmuttalbe,
          )) {
            finalSet.remove(indexOfGridItemThatStartedTheHoldUnmuttalbe);
          } else {
            finalSet.add(indexOfGridItemThatStartedTheHoldUnmuttalbe);
          }
          if (lastSelectedReservationsSnapshot!.contains(
            indexOfCurrentGridItem,
          )) {
            finalSet.remove(indexOfCurrentGridItem);
          } else {
            finalSet.add(indexOfCurrentGridItem);
          }
          //! Minor adjustments for a smoother experience.
          //! ( First and last items of the colections )

          setState(() {
            setOfIndicesOfSelectedReservations = finalSet;
          });
        }
      }
    }
  }

  void tapHandler(int listIndex) {
    return setState(() {
      if (setOfIndicesOfSelectedReservations.contains(listIndex)) {
        setOfIndicesOfSelectedReservations.remove(listIndex);
      } else {
        setOfIndicesOfSelectedReservations.add(listIndex);
      }
    });
  }

  void stopHolding(details) {
    setState(() {
      isHolding = false;
      indexOfTheGridItemThatStartedTheHold = null;
      lastSelectedReservationsSnapshot = null;
    });
  }

  void startHolding(details) {
    setState(() {
      isHolding = true;
    });
  }

  void selectAll() {
    setState(() {
      setOfIndicesOfSelectedReservations = List<int>.generate(
        widget.reservations.length,
        (index) => index,
      ).toSet();
    });
  }

  void unselectAll() {
    setState(() {
      setOfIndicesOfSelectedReservations = {};
    });
  }
}
