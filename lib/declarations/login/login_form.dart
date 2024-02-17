import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/core/errors/exceptions.dart';
import 'package:decla_time/core/extensions/capitalize.dart';
import 'package:decla_time/core/widgets/column_with_spacings.dart';
import 'package:decla_time/declarations/login/remember_username_checkbox.dart';
import 'package:decla_time/declarations/login/user_credentials_provider.dart';
import 'package:decla_time/declarations/utility/network_requests/login/login_user.dart';
import 'package:decla_time/declarations/utility/user_credentials.dart';
import 'package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/required_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.localized,
    required this.initialUsername,
  });

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
  bool isLoading = false;

  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.initialUsername;
    if (widget.initialUsername.isNotEmpty) {
      rememberUsername = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final declarationsAccountProvider =
        context.watch<DeclarationsAccountController>();

    return isLoading
        ? const CircularProgressIndicator()
        : SizedBox(
            width: kFormFieldWidth,
            child: Form(
              key: _formKey,
              child: ColumnWithSpacings(
                spacing: 16,
                children: [
                  SizedBox(
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
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setLoadingStatus(true);
                        final credentials = UserCredentials(
                            username: usernameController.text,
                            password: passwordController.text);

                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setString(
                            kGovUsername,
                            rememberUsername ? credentials.username : "",
                          );
                        });

                        await attemptLogin(
                          credentials,
                          declarationsAccountProvider,
                        );
                      }
                      setLoadingStatus(false);
                    },
                    child: Text(
                      "Log in",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Future<void> attemptLogin(
    UserCredentials credentials,
    DeclarationsAccountController declarationsAccountProvider,
  ) async {
    try {
      final headers = await loginUser(credentials: credentials);
      declarationsAccountProvider.setUserCredentials(credentials);
      declarationsAccountProvider.setDeclarationsPageHeaders(headers);
    } on LoginFailedExcepetion {
      setErrorMessage(widget.localized.errorLoginFailed.capitalized);
    } on ClientException {
      setErrorMessage(widget.localized.errorNoConnection.capitalized);
    } catch (any) {
      setErrorMessage(widget.localized.errorUnknown.capitalized);
    }
  }

  void setRememberUsername(bool? remember) {
    setState(() {
      rememberUsername = remember ?? false;
    });
  }

  void setLoadingStatus(bool newLoadingStatus) {
    if (isLoading != newLoadingStatus) {
      setState(() {
        isLoading = newLoadingStatus;
      });
    }
  }

  void setErrorMessage(String newErrorMessage) {
    if (newErrorMessage != errorMessage) {
      setState(() {
        errorMessage = "*$newErrorMessage.";
      });
    }
  }
}
