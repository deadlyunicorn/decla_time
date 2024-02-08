import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/functions/list_of_string_to_list_of_widget.dart';
import 'package:decla_time/reservations_action_button_menu/getting_reservation_files_instructions/platform_file_instructions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingComFileInstructions extends StatelessWidget {
  const BookingComFileInstructions({super.key, required this.localized});

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    final dateFormattedToday = DateFormat("y-MM-dd").format(DateTime.now());
    final dateFormatted3MonthsAgo = DateFormat("y-MM-dd").format(
      DateTime.now().subtract(
        const Duration(days: 3 * kMonthInDays),
      ),
    );

    return PlatformFileInstructions(
      localized: localized,
      platformName: "Booking.com",
      platformFilesURL:
          "https://admin.booking.com/hotel/hoteladmin/extranet_ng/manage/search_reservations.html?upcoming_reservations=1&hotel_id=null&ses=null&date_from=$dateFormatted3MonthsAgo&date_to=$dateFormattedToday&date_type=arrival",
      imageAssetNames: [
        "01.png",
        "02.png",
        "03.png",
        "04.png",
        "05.png",
        "06.png",
        "07.png",
      ]
          .map<String>(
              (filename) => "assets/images/booking_com_instructions/$filename")
          .toList(),
      instructionsDescription: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...listOfStringToListOfWidget([
            "${localized.getTheFilesPrompt.capitalized} '${localized.getTheFiles.capitalized}'",
            (localized.loginIfNeeded.capitalized),
            (localized.selectTheDatesToImport.capitalized),
            "${localized.clickOnDownloadAndWait.capitalized}. ${localized.whenReadyDownload.capitalized}",
            localized.needToConvert.capitalized,
          ]),
          TextButton(
            onPressed: () {
              launchUrl(
                Uri.parse("https://www.deadlyunicorn.dev/spreadsheets"),
                mode: LaunchMode.platformDefault
              );
            },
            child: Text("${localized.goTo.capitalized} Google Sheets"),
          ),
          ...listOfStringToListOfWidget([
            "${localized.convertWithHelp.capitalized} Sheets",
            localized.yourFilesAreReady.capitalized
          ], countStart: 5)
        ]),
      ),
    );
  }
}
