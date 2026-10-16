/// Base class for low-level exceptions thrown by the data layer.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Thrown when a network/server call fails.
class ServerException extends AppException {
  const ServerException([super.message = 'Server error']);
}

/// Thrown when a local cache/storage operation fails.
class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

/// Thrown when a requested entity cannot be found.
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not found']);
}

/// Thrown when authentication fails.
class AuthException extends AppException {
  const AuthException([super.message = 'Authentication failed']);
}
