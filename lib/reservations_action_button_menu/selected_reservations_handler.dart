import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:provider/provider.dart";

class SelectedReservationsHandler extends StatelessWidget {
  const SelectedReservationsHandler({
    required this.setOfIndicesOfSelectedItems,
    required this.reservations,
    required this.removeFromReservationsFoundSoFar,
    required this.localized,
    super.key,
  });

  final Set<int> setOfIndicesOfSelectedItems;
  final List<Reservation> reservations;
  final void Function(Iterable<Reservation>) removeFromReservationsFoundSoFar;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return setOfIndicesOfSelectedItems.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              //Submit button
              //Submit Button
              onPressed: () async {
                await context
                    .read<IsarHelper>()
                    .reservationActions
                    .insertMultipleEntriesToDb(
                      setOfIndicesOfSelectedItems
                          .map(
                            (int index) => reservations[index],
                          )
                          .toList(),
                    );
                removeFromReservationsFoundSoFar(
                  setOfIndicesOfSelectedItems.map(
                    (int index) => reservations[index],
                  ),
                );
                setOfIndicesOfSelectedItems.clear();
              },
              child: Text(
                // ignore: lines_longer_than_80_chars
                "${localized.addSelected.capitalized} (${setOfIndicesOfSelectedItems.length})",
                textAlign: TextAlign.center,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
