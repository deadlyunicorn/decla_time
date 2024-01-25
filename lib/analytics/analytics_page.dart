import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/extensions/text_button_error.dart';
import 'package:decla_time/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localized = AppLocalizations.of(context)!;

    return Column(
      children: [
        const Expanded(child: Text("Analytics here")),
        Center(
          child: TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
            onPressed: () {
              context.read<SettingsController>().toggleLocale();
            },
            child: Text(
              localized.localeFlag,
            ),
          ),
        ),
        Center(
          child: TextButton(
            style: Theme.of(context).textButtonErrorTheme.style,
            onPressed: () async {
              final isarFuture = context.read<IsarHelper>().isarFuture;
              final prefsFuture = SharedPreferences.getInstance();

              final [ isar as Isar ,prefs as SharedPreferences ] = await Future.wait([isarFuture,prefsFuture]);

              await isar.writeTxn(() async {
                await isar.clear();
              });

              await prefs.setStringList(kListings, []);
              await prefs.setStringList(kBookingPlatforms, []);
              await prefs.setStringList(kReservationListing, []);
              await prefs.setStringList(kReservationStatus, []);
            },
            child: Text(
              "Clear everything",
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        )
      ],
    );
  }
}
