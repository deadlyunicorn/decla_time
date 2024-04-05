import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/extensions/text_button_error.dart";
import "package:decla_time/settings.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:isar/isar.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

class AppSettings extends StatelessWidget {
  const AppSettings({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          localized.appSettings.capitalized,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox.square(dimension: 16,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("${localized.selectLanguage.capitalized}: "),
            ToggleLocaleButton(localized: localized),
          ],
        ),
        TextButton(
          style: Theme.of(context).textButtonErrorTheme.style,
          onPressed: () async {
            final Future<Isar> isarFuture =
                context.read<IsarHelper>().isarFuture;
            final Future<SharedPreferences> prefsFuture =
                SharedPreferences.getInstance();

            final [
              Isar isar as Isar,
              SharedPreferences prefs as SharedPreferences
            ] = await Future.wait(<Future<Object?>>[isarFuture, prefsFuture]);

            await isar.writeTxn(() async {
              await isar.clear();
            });

            await prefs.setStringList(kListings, <String>[]);
            await prefs.setStringList(kBookingPlatforms, <String>[]);
            await prefs.setStringList(kReservationListing, <String>[]);
            await prefs.setStringList(kReservationStatus, <String>[]);
          },
          child: Text(
            localized.clearAllData.capitalized,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
    );
  }
}

class ToggleLocaleButton extends StatelessWidget {
  const ToggleLocaleButton({
    required this.localized,
    super.key,
  });

  final AppLocalizations localized;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onPressed: () {
        context.read<SettingsController>().toggleLocale();
      },
      child: Text(
        localized.localeFlag,
      ),
    );
  }
}
