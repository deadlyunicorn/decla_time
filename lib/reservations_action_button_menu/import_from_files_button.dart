import 'dart:io';

import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/reservations/business/reservation.dart';
import 'package:decla_time/reservations/business/reservation_actions.dart';
import 'package:decla_time/reservations_action_button_menu/import_manually_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';

class ImportFromFilesButton extends StatelessWidget {
  const ImportFromFilesButton({
    super.key,
    required this.reservationsFoundSoFar,
    required this.addToReservationsFoundSoFar,
  });

  final List<Reservation> reservationsFoundSoFar;
  final void Function(Iterable<Reservation> reservations)
      addToReservationsFoundSoFar;

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return ImportManuallyButton(
      description: localized.addFromFile.capitalized,
      icon: Icons.file_copy,
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Tooltip(
            message: localized.howToGetTheFiles.capitalized,
            child: IconButton(
              onPressed: () {
                print("Pop up that shows instructions");
              },
              icon: const Icon(Icons.question_mark_rounded),
            ),
          ),
        )
      ],
      onTap: () {
        getFilesFromFileSystem(context);
      },
      // onTap: getFilesFromFileSystem,
      //functions to add...
    );
  }

  void getFilesFromFileSystem(BuildContext context) async {
    final localized = AppLocalizations.of(context)!;

    final filePickerResults = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ["csv"],
    );

    if (filePickerResults != null) {
      //User did select files

      final List<File> files = filePickerResults
          .paths //this is for type safety ( due to API mishaps.. )
          .where(
            (path) => path != null,
          )
          .map(
            (path) => File(path!),
          )
          .toList();

      if (files.isNotEmpty) {
        //If files are not selected you cannot submit anyways.
        ReservationFolderActions.generateReservationTableFromMultipleFiles(
          files,
        ).then(
          (reservationsFromFile) {
            final Set<String> alreadyFoundIds = reservationsFoundSoFar
                .map((reservation) => reservation.id)
                .toSet();

            final newReservationEntries = reservationsFromFile.where(
              //make sure we don't add duplicates
              (reservation) => !alreadyFoundIds.contains(reservation.id),
            );

            if (newReservationEntries.isEmpty) {
              //No new reservations found -
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text(localized.newReservationsNotFound.capitalized),
                  ),
                ),
              );
            } else {
              //Found new reservations

              final newReservationCount = newReservationEntries.length;

              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(
                    child: Text(
                      "${localized.found.capitalized} $newReservationCount ${newReservationCount > 1 ? localized.reservations : localized.reservation}.",
                    ),
                  ),
                ),
              );

              addToReservationsFoundSoFar(newReservationEntries);
            }
          },
        );
      }
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: Text(localized.reservationsNotAdded.capitalized),
          ),
        ),
      );
    }
  }
}
