import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/reservations/reservation_place.dart";
import "package:decla_time/reservations_action_button_menu/manual_entry_route/reservation_manual_entry_dropdown_field_outline.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:isar/isar.dart";
import "package:provider/provider.dart";

class ReservationPlaceField extends StatelessWidget {
  const ReservationPlaceField({
    required this.localized,
    required this.listingNameController,
    super.key,
  });

  final AppLocalizations localized;
  final TextEditingController listingNameController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DropdownMenuEntry<String>>>(
      future: getReservationPlacesFromDatabaseAsDropdownMenuEntries(
        context: context,
      ),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<DropdownMenuEntry<String>>> snapshot,
      ) {
        return ReservationManualEntryDropdownFieldOutline(
          //Spaghetti code :)
          localized: localized,
          textEditingController: listingNameController,
          sharedPrefsListKey: "whoDidWriteThis",
          dropdownMenuEntriesFuture:
              getReservationPlacesFromDatabaseAsDropdownMenuEntries,
          addNewEntryFuture: addNewPlaceFuture,
          label: "${localized.listingPlace}*",
          isRequired: true,
        );
      },
    );
  }

  Future<List<DropdownMenuEntry<String>>>
      getReservationPlacesFromDatabaseAsDropdownMenuEntries({
    required BuildContext context,
  }) async {
    final Isar isar = await context.read<IsarHelper>().isarFuture;

    return (await isar.reservationPlaces.where().sortByFriendlyName().findAll())
        .map(
          (ReservationPlace reservationPlace) => DropdownMenuEntry<String>(
            value: "${reservationPlace.id}",
            label: reservationPlace.friendlyName,
          ),
        )
        .toList();
  }

  Future<void> addNewPlaceFuture({
    required BuildContext context,
    required String newEntry,
  }) async {
    final Isar isar = await context.read<IsarHelper>().isarFuture;
    await isar.writeTxn(() async {
      await isar.reservationPlaces
          .put(ReservationPlace(friendlyName: newEntry));
    });

    if (context.mounted) {
      context.read<IsarHelper>().update();
    }
  }
}
