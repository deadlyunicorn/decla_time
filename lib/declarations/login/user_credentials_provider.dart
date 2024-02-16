import 'package:decla_time/declarations/utility/network_requests/headers/declarations_page_headers.dart';
import 'package:decla_time/declarations/utility/user_credentials.dart';
import 'package:flutter/material.dart';

class DeclarationsAccountNotifier extends ChangeNotifier {
  UserCredentials? _userCredentials;
  DeclarationsPageHeaders? _headers;

  UserCredentials? get userCredentials => _userCredentials;
  DeclarationsPageHeaders? get headers => _headers;

  void setUserCredentials(UserCredentials userCredentials) {
    _userCredentials = userCredentials;
    notifyListeners();
  }

  void setDeclarationsPageHeaders(DeclarationsPageHeaders headers) {
    _headers = headers;
    notifyListeners();
  }
}
