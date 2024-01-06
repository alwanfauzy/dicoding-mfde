class ServerException implements Exception {}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}

class SSLException implements Exception {
  final String message;

  SSLException(this.message);
}
