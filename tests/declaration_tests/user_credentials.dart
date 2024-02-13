// ignore_for_file: non_constant_identifier_names

class LoginBodyFields {
  final String _username;
  final String _password;
  final String _requestId;

  LoginBodyFields( {required String username, required String password, required requestId})
      : _username = username,
        _password = password,
        _requestId = requestId;

  String get loginBody => "request_id=$_requestId&username=$_username&password=$_password&btn_login=";
}
