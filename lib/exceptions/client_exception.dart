class ClientException implements Exception {
  // Message to show it to the user
  String? _message;

  ClientException([String message = 'Error in client side. Please try again']) {
    this._message = message;
  }

  @override
  String toString() {
    return _message!;
  }
}
