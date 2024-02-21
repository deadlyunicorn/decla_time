import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/declarations/database/user/user.dart';
import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/user_credentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersController extends ChangeNotifier {
  String _selectedUser;
  String _selectedPropertyId;
  List<User> _availableUsers;
  final IsarHelper _isarHelper;

  LoggedUser? _loggedUser;

  bool _requestLogin = false;

  List<User> get users => _availableUsers;
  String get selectedUser => _selectedUser;
  bool get requestLogin => _requestLogin;
  bool get isLoggedIn => (loggedUser.userCredentials != null &&
      loggedUser.userCredentials?.username == selectedUser);
  String get selectedProperty => _selectedPropertyId;

  UsersController({
    required List<User> availableUsers,
    required String selectedUser,
    required IsarHelper isarHelper,
    String? propertyId,
  })  : _availableUsers = availableUsers,
        _selectedUser = selectedUser,
        _selectedPropertyId = propertyId ?? "",
        _isarHelper = isarHelper;

  void setRequestLogin(bool newValue) {
    if (newValue == _requestLogin) return;
    _requestLogin = newValue;
    notifyListeners();
  }

  Future<void> selectProperty(String propertyId) async {
    if (propertyId == _selectedPropertyId) return;

    final userThatOwnsPropert = _availableUsers
        .where((user) => user.propertyIds.contains(propertyId))
        .firstOrNull;
    if (userThatOwnsPropert == null) return;
    if (userThatOwnsPropert.username != selectedUser) {
      await selectUser(userThatOwnsPropert.username);
    }

    _selectedPropertyId = propertyId;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(kLastSelectedPropertyId, propertyId);

    notifyListeners();
  }

  Future<void> selectUser(String username) async {
    if (username == _selectedUser) return;
    _selectedUser = username;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(kLastSelectedUser, username);

    await selectProperty("");

    notifyListeners();
  }

  void sync() async {
    _availableUsers = await _isarHelper.userActions.getAll();
    notifyListeners();
  }

  static Future<UsersController> initialize(IsarHelper isarHelper) async {
    final prefs = await SharedPreferences.getInstance();
    final rememberedUsername = prefs.getString(kGovUsername) ?? "";

    final String lastSelectedUsername = rememberedUsername.isNotEmpty
        ? rememberedUsername
        : prefs.getString(kLastSelectedUser) ?? "";

    final String lastSelectedProperty =
        prefs.getString(kLastSelectedPropertyId) ?? "";

    final List<User> users = await isarHelper.userActions.getAll();

    return UsersController(
      availableUsers: users,
      selectedUser: lastSelectedUsername,
      propertyId: lastSelectedProperty,
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

  LoggedUser({required notifyListeners}) : _notifyListeners = notifyListeners;

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
