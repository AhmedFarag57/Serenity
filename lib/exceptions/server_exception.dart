class ServerException implements Exception {
  // Message to show it to the user
  String? _message;

  ServerException([String message = 'Error in server side. Please try again']) {
    this._message = message;
  }

  @override
  String toString() {
    return _message!;
  }
}
