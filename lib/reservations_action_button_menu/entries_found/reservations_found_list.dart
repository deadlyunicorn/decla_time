import 'dart:math';

import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_grid_item_container.dart';
import 'package:decla_time/reservations_action_button_menu/entries_found/is_selected_underline.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ReservationsFoundList extends StatefulWidget {
  const ReservationsFoundList({
    super.key,
    required this.reservations,
  });

  final List<Reservation> reservations;

  @override
  State<ReservationsFoundList> createState() => _ReservationsFoundListState();
}

class _ReservationsFoundListState extends State<ReservationsFoundList> {

  Set<int> selectedReservations = {};

  bool isHolding = false;
  Set<int>? lastSelectedReservationsSnapshot;
  int? indexOfTheGridItemThatStartedTheHold;

  @override
  Widget build(BuildContext context) {
    
    final localized = AppLocalizations.of(context)!;

    if (widget.reservations.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return SizedBox(
        width: min(MediaQuery.sizeOf(context).width, kMaxWidthLargest),
        child: Padding(
          padding: const EdgeInsets.symmetric( vertical: 16.0),
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
                        child: Text( localized.clearSelection.capitalized ),
                      ),
                      TextButton(
                        onPressed: selectAll,
                        child: Text( localized.selectAll.capitalized ),
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
                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all( 32),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: kMaxContainerWidthSmall,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: widget.reservations.length,
                    itemBuilder: (context, indexOfCurrentGridItem) {
                      final reservation =
                          widget.reservations[indexOfCurrentGridItem];
                      final nights = reservation.departureDate
                          .difference(reservation.arrivalDate)
                          .inDays;

                      return Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            clipBehavior: Clip.antiAlias,
                            color: Theme.of(context).colorScheme.secondary,
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
                                    child: ReservationGridItemContainerItems(
                                      //Items.
                                      localized: localized,
                                      nights: nights,
                                      reservation: reservation,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: IsSelectedUnderline(
                                        isSelected: selectedReservations
                                            .contains(indexOfCurrentGridItem)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: -8,
                            top: -8,
                            child: Tooltip(
                              preferBelow: false,
                              message: "Hello!",
                              child: Icon(
                                Icons.info,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              selectedReservations.isNotEmpty
                  ? TextButton(
                      //Submit button
                      //Submit Button
                      onPressed: () async {
                        await context
                            .read<IsarHelper>()
                            .insertMultipleEntriesToDb(selectedReservations
                                .map((index) => widget.reservations[index])
                                .toList());
                      },
                      child:
                          Text("${localized.addSelected.capitalized}. (${selectedReservations.length})"),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      );
    }
  }

  void hoverHandler(int indexOfCurrentGridItem) {
    if (isHolding) {
      if (indexOfTheGridItemThatStartedTheHold == null) {
        indexOfTheGridItemThatStartedTheHold =
            indexOfCurrentGridItem; //keep track of where the hold started from.
        lastSelectedReservationsSnapshot = //keep track of the previously selected items.
            selectedReservations;
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

          Set<int> finalSet = selectedReservations = {
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
            selectedReservations = finalSet;
          });
        }
      }
    }
  }

  void tapHandler(int listIndex) {
    return setState(() {
      if (selectedReservations.contains(listIndex)) {
        selectedReservations.remove(listIndex);
      } else {
        selectedReservations.add(listIndex);
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
      selectedReservations = List<int>.generate(
        widget.reservations.length,
        (index) => index,
      ).toSet();
    });
  }

  void unselectAll() {
    setState(() {
      selectedReservations = {};
    });
  }
}
