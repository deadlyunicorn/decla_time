import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/declarations/login/remember_username_checkbox.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/required_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.setLoginStatus,
    required this.localized,
    required this.initialUsername,
  });

  final void Function(bool newStatus) setLoginStatus;
  final AppLocalizations localized;
  final String initialUsername;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool rememberUsername = false;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.initialUsername;
    if( widget.initialUsername.isNotEmpty ){
      rememberUsername = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 16,
        spacing: 16,
        direction: Axis.vertical,
        children: [
          SizedBox(
            width: kFormFieldWidth,
            child: Text(
              "Login Form",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          RequiredTextField(
            localized: widget.localized,
            label: "Username",
            controller: usernameController,
          ),
          RequiredTextField(
            localized: widget.localized,
            label: "password",
            controller: passwordController,
            obscureText: true,
          ),
          RememberUsernameCheckbox(
            rememberUsername: rememberUsername,
            setRememberUsername: setRememberUsername,
          ),
          SizedBox(
            width: kFormFieldWidth,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final username = usernameController.text;
                    final password = passwordController.text;

                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setString(
                        kGovUsername,
                        rememberUsername ? username : "",
                      );
                    });

                    widget.setLoginStatus(true);
                  }
                },
                child: Text(
                  "Log in",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setRememberUsername(bool? remember) {
    setState(() {
      rememberUsername = remember ?? false;
    });
  }
}
