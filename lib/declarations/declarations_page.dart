import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/declarations/login/login_form.dart';
import 'package:decla_time/declarations/login/user_credentials_provider.dart';
import 'package:decla_time/declarations/synced_declarations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeclarationsPage extends StatelessWidget {
  const DeclarationsPage({super.key, required this.localized});

  final AppLocalizations localized;
  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        context.watch<DeclarationsAccountNotifier>().userCredentials != null;

    return isLoggedIn
        ? SyncedDeclarations(
            localized: localized,
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: FutureBuilder<String>(
                  future: getSavedUsernameFuture(),
                  builder: (context, snapshot) {
                    final username = snapshot.data;

                    return snapshot.connectionState == ConnectionState.done
                        ? LoginForm(
                            initialUsername: username ?? "",
                            localized: localized,
                          )
                        : const CircularProgressIndicator();
                  }),
            ),
          );
  }

  Future<String> getSavedUsernameFuture() async {
    return await SharedPreferences.getInstance()
        .then((prefs) => prefs.getString(kGovUsername) ?? "");
  }
}
