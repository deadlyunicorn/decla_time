import 'package:decla_time/core/connection/isar_helper.dart';
import 'package:decla_time/core/constants/constants.dart';
import 'package:decla_time/declarations/database/user/user.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersController extends ChangeNotifier {
  String _selectedUser;
  List<User> _availableUsers;
  final IsarHelper _isarHelper;

  String get selectedUser => _selectedUser;

  UsersController({
    required List<User> availableUsers,
    required String selectedUser,
    required IsarHelper isarHelper,
  })  : _availableUsers = availableUsers,
        _selectedUser = selectedUser,
        _isarHelper = isarHelper;

  Future<void> selectUser(String username) async {
    _selectedUser = username;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(kLastSelectedUser, username);

    notifyListeners();
  }

  List<User> get users => _availableUsers;

  void sync() async {
    _availableUsers = await _isarHelper.userActions.getAll();
    notifyListeners();
  }

  static Future<UsersController> initialize(IsarHelper isarHelper) async {
    final prefs = await SharedPreferences.getInstance();
    final String lastSelectedUsername =
        prefs.getString(kLastSelectedUser) ?? "";

    final List<User> users = await isarHelper.userActions.getAll();

    return UsersController(
      availableUsers: users,
      selectedUser: lastSelectedUsername,
      isarHelper: isarHelper,
    );
  }
}
