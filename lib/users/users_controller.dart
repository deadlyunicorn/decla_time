import "dart:async";

import "package:decla_time/core/connection/isar_helper.dart";
import "package:decla_time/core/constants/constants.dart";
import "package:decla_time/declarations/database/user/user.dart";
import "package:decla_time/declarations/database/user/user_property.dart";
import "package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart";
import "package:decla_time/declarations/utility/user_credentials.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class UsersController extends ChangeNotifier {
  String _selectedUser;
  UserProperty? _selectedProperty;
  List<User> _availableUsers;
  final IsarHelper _isarHelper;

  LoggedUser? _loggedUser;

  bool _requestLogin = false;

  List<User> get users => _availableUsers;
  String get selectedUser => _selectedUser;
  UserProperty? get selectedProperty => _selectedProperty;


  bool get requestLogin => _requestLogin;
  bool get isLoggedIn => (loggedUser.userCredentials != null &&
      loggedUser.userCredentials?.username == selectedUser);

  UsersController({
    required List<User> availableUsers,
    required String selectedUser,
    required IsarHelper isarHelper,
    required UserProperty? property,
  })  : _availableUsers = availableUsers,
        _selectedUser = selectedUser,
        _selectedProperty = property,
        _isarHelper = isarHelper;

  void setRequestLogin(bool newValue) {
    if (newValue == _requestLogin) return;
    _requestLogin = newValue;
    notifyListeners();
  }

  Future<void> selectProperty(String propertyId) async {
    if (propertyId == _selectedProperty?.propertyId) return;

    final User? userThatOwnsPropert = _availableUsers
        .where((User user) => user.propertyIds.contains(propertyId))
        .firstOrNull;
    if (userThatOwnsPropert == null) return;
    if (userThatOwnsPropert.username != selectedUser) {
      await selectUser(userThatOwnsPropert.username);
    }

    _selectedProperty =
        await _isarHelper.userActions.getProperty(propertyId: propertyId);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    unawaited(prefs.setString(kLastSelectedPropertyId, propertyId));

    notifyListeners();
  }

  Future<void> selectUser(String username) async {
    if (username == _selectedUser) return;
    _selectedUser = username;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    unawaited(prefs.setString(kLastSelectedUser, username));

    await selectProperty("");

    notifyListeners();
  }

  Future<void> sync() async {
    _availableUsers = await _isarHelper.userActions.getAll();
    if (_selectedProperty != null) {
      _selectedProperty = await _isarHelper.userActions
          .getProperty(propertyId: _selectedProperty!.propertyId);
    }

    notifyListeners();
  }

  static Future<UsersController> initialize(IsarHelper isarHelper) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String rememberedUsername = prefs.getString(kGovUsername) ?? "";

    String lastSelectedUsername = rememberedUsername.isNotEmpty
        ? rememberedUsername
        : prefs.getString(kLastSelectedUser) ?? "";

    UserProperty? lastSelectedProperty =
        await isarHelper.userActions.getProperty(
      propertyId: prefs.getString(kLastSelectedPropertyId) ?? "",
    );

    final List<User> users = await isarHelper.userActions.getAll();
    if (users
        .where((User user) => user.username.contains(lastSelectedUsername))
        .isEmpty) {
      lastSelectedUsername = "";
      lastSelectedProperty = null;
    } else if ((await isarHelper.userActions
            .readProperties(username: lastSelectedUsername))
        .where(
          (UserProperty property) =>
              property.propertyId == lastSelectedProperty?.propertyId,
        )
        .isEmpty) {
      lastSelectedProperty = null;
    }

    return UsersController(
      availableUsers: users,
      selectedUser: lastSelectedUsername,
      property: lastSelectedProperty,
      isarHelper: isarHelper,
    );
  }

  LoggedUser get loggedUser {
    LoggedUser initializedLoggedUser =
        _loggedUser ?? LoggedUser(notifyListeners: notifyListeners);
    _loggedUser ??= initializedLoggedUser;
    return initializedLoggedUser;
  }
}

class LoggedUser {
  final void Function() _notifyListeners;

  LoggedUser({required void Function() notifyListeners})
      : _notifyListeners = notifyListeners;

  UserCredentials? _userCredentials;
  DeclarationsPageHeaders? _headers;

  UserCredentials? get userCredentials => _userCredentials;
  DeclarationsPageHeaders? get headers => _headers;

  void setUserCredentials(UserCredentials userCredentials) {
    _userCredentials = userCredentials;
    _notifyListeners();
  }

  void setDeclarationsPageHeaders(DeclarationsPageHeaders headers) {
    _headers = headers;
    _notifyListeners();
  }
}
