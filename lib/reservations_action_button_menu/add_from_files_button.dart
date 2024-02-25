import "dart:io";

import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/reservations/business/extracting_from_file_actions.dart";
import "package:decla_time/reservations/reservation.dart";
import "package:decla_time/reservations_action_button_menu/getting_reservation_files_instructions/getting_reservation_files_instructions_route.dart";
import "package:decla_time/reservations_action_button_menu/reservation_addition_button_outline.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import "package:flutter/material.dart";

class AddReservationsFromFileButton extends StatelessWidget {
  const AddReservationsFromFileButton({
    required this.reservationsAlreadyImported,
    required this.addToReservationsFoundSoFar,
    required this.localized,
    super.key,
  });

  final List<Reservation> reservationsAlreadyImported;
  final void Function(Iterable<Reservation> reservations)
      addToReservationsFoundSoFar;
  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return ReservationAdditionButtonOutline(
      description: localized.addFromFile.capitalized,
      icon: Icons.file_copy,
      children: <Widget>[
        Positioned(
          top: 0,
          right: 0,
          child: Tooltip(
            message: localized.howToGetTheFiles.capitalized,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        GettingReservationFilesInstructionsRoute(
                      localized: localized,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.question_mark_rounded),
            ),
          ),
        ),
      ],
      onTap: () {
        getFilesFromFileSystem(context);
      },
      // onTap: getFilesFromFileSystem,
      //functions to add...
    );
  }

  Future<void> getFilesFromFileSystem(BuildContext context) async {
    final FilePickerResult? filePickerResults =
        await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: <String>["csv"],
    );

    if (filePickerResults != null && context.mounted) {
      //User did select files

      final List<File> files = filePickerResults
          .paths //this is for type safety ( due to API mishaps.. )
          .where(
            (String? path) => path != null,
          )
          .map(
            (String? path) => File(path!),
          )
          .toList();

      addToReservationsFoundSoFar(
        await ExtractingReservationsFromFileActions
                .handleReservationAdditionFromFiles(
              files,
              context,
              localized,
              reservationsAlreadyImported,
            ) ??
            <Reservation>[],
      );
    } else if (context.mounted) {
      ExtractingReservationsFromFileActions.noReservationsAddedSnackbar(
        context,
        localized,
      );
    }
  }
}
