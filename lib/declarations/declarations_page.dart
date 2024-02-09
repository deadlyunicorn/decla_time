import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/declarations/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeclarationsPage extends StatefulWidget {
  const DeclarationsPage({super.key, required this.localized});

  final AppLocalizations localized;
  @override
  State<DeclarationsPage> createState() => _DeclarationsPageState();
}

class _DeclarationsPageState extends State<DeclarationsPage> {
  bool isLogged = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          const SizedBox.square(
            dimension: 32,
          ),
          Center(
            child: FutureBuilder<String>(
              future: getSavedUsernameFuture(),
              builder: (context, snapshot) {
                final username = snapshot.data;
                
                if (snapshot.connectionState == ConnectionState.done) {
                  return LoginForm(
                    initialUsername: username ?? "",
                    localized: widget.localized,
                    setLoginStatus: setLoginStatus,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Text("logged in: $isLogged")
        ],
      ),
    );
  }

  void setLoginStatus(bool newStatus) {
    setState(() {
      isLogged = newStatus;
    });
  }

  Future<String> getSavedUsernameFuture() async {
    return await SharedPreferences.getInstance()
        .then((prefs) => prefs.getString(kGovUsername) ?? "");
  }
}
