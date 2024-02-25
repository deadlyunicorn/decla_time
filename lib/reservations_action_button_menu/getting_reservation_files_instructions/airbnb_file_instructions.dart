import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/functions/list_of_string_to_list_of_widget.dart";
import "package:decla_time/reservations_action_button_menu/getting_reservation_files_instructions/platform_file_instructions.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter/material.dart";

class AirbnbFileInstructions extends StatelessWidget {
  const AirbnbFileInstructions({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return PlatformFileInstructions(
      localized: localized,
      platformName: "Airbnb",
      platformFilesURL: "https://www.airbnb.com/hosting/reservations/completed",
      imageAssetNames: const <String>[
        "assets/images/airbnb_instructions/01.png",
      ],
      instructionsDescription: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: listOfStringToListOfWidget(<String>[
            // ignore: lines_longer_than_80_chars
            "${localized.getTheFilesPrompt.capitalized} '${localized.getTheFiles.capitalized}'",
            localized.loginIfNeeded.capitalized,
            localized.selectTheDatesToImport.capitalized,
            localized.clickOnExportLikeBelow.capitalized,
            localized.yourFilesAreReady.capitalized,
          ]),
        ),
      ),
    );
  }
}
