import 'package:decla_time/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
                borderRadius: BorderRadius.circular( 4 )
              )
            ),
            onPressed: () {
              context.read<SettingsController>().toggleLocale();
            },
            child: Text(
              localized.localeFlag,
            ),
          ),
        ),
      ],
    );
  }
}
