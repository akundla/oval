class AuthToken {
  static final AuthToken _authToken = new AuthToken._internal();
  
  String value;
  
  factory AuthToken() {
    return _authToken;
  }

  AuthToken._internal();
}

final authToken = AuthToken();
