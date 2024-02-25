class UserCredentials {
  final String _username;
  final String _password;

  String get username => _username;

  UserCredentials({required String username, required String password})
      : _username = username,
        _password = password;

  String generateLoginBody(String requestId) =>
      // ignore: lines_longer_than_80_chars
      "request_id=$requestId&username=$_username&password=$_password&btn_login=";
}
