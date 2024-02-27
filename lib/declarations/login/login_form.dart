import "dart:async";

import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/core/errors/exceptions.dart";
import "package:decla_time/core/extensions/capitalize.dart";
import "package:decla_time/core/widgets/column_with_spacings.dart";
import "package:decla_time/declarations/login/remember_username_checkbox.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/network_requests/login/login_user.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:decla_time/reservations/presentation/widgets/reservation_form/form_fields/required_text_field.dart";
import "package:decla_time/users/users_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:http/http.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.localized,
    required this.initialUsername,
    super.key,
  });

  final AppLocalizations localized;
  final String initialUsername;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
  void didChangeDependencies() {
    usernameController.text = context.watch<UsersController>().selectedUser;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final UsersController usersController = context.watch<UsersController>();
    final IsarHelper isarHelper = context.watch<IsarHelper>();

    return isLoading
        ? SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Column(
            children: <Widget>[
              SizedBox(
                child: Text(
                  widget.localized.loginForm.capitalizedAll,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
              const SizedBox.square(
                dimension: 32,
              ),
              SizedBox(
                width: kFormFieldWidth,
                child: Form(
                  key: _formKey,
                  child: ColumnWithSpacings(
                    spacing: 16,
                    children: <Widget>[
                      RequiredTextField(
                        submitFormHandler: () {
                          submitLoginForm(isarHelper, usersController);
                        },
                        localized: widget.localized,
                        label: widget.localized.username.capitalized,
                        controller: usernameController,
                      ),
                      RequiredTextField(
                        submitFormHandler: () {
                          submitLoginForm(isarHelper, usersController);
                        },
                        localized: widget.localized,
                        label: widget.localized.password.capitalized,
                        controller: passwordController,
                        obscureText: true,
                      ),
                      RememberUsernameCheckbox(
                        localized: widget.localized,
                        rememberUsername: rememberUsername,
                        setRememberUsername: setRememberUsername,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          submitLoginForm(isarHelper, usersController);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.localized.login.capitalized,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
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
              ),
            ],
          );
  }

  Future<void> submitLoginForm(
    IsarHelper isarHelper,
    UsersController usersController,
  ) async {
    if (_formKey.currentState!.validate()) {
      setLoadingStatus(true);
      final UserCredentials credentials = UserCredentials(
        username: usernameController.text,
        password: passwordController.text,
      );

      unawaited(
        SharedPreferences.getInstance().then(
          (SharedPreferences prefs) {
            prefs.setString(
              kGovUsername,
              rememberUsername ? credentials.username : "",
            );
          },
        ),
      );

      final DeclarationsPageHeaders? loginResult = await attemptLogin(
        credentials,
      );

      if (loginResult != null) {
        await isarHelper.userActions //? Keep in db
            .addNew(username: credentials.username)
            .then((_) {
          usersController.selectUser(credentials.username);
          usersController.sync();
        });
        usersController.loggedUser
          ..setUserCredentials(credentials)
          ..setDeclarationsPageHeaders(loginResult);
      }
    }
    setLoadingStatus(false);
  }

  Future<DeclarationsPageHeaders?> attemptLogin(
    UserCredentials credentials,
  ) async {
    try {
      final DeclarationsPageHeaders headers =
          await loginUser(credentials: credentials);
      return headers;
    } on LoginFailedExcepetion {
      setErrorMessage(widget.localized.errorLoginFailed.capitalized);
    } on TryAgainLaterException {
      setErrorMessage(widget.localized.tryAgainLater.capitalized);
    } on ClientException {
      setErrorMessage(widget.localized.errorNoConnection.capitalized);
    } catch (any) {
      setErrorMessage(widget.localized.errorUnknown.capitalized);
    }
    return null;
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
