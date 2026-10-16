import 'package:equatable/equatable.dart';

/// User-facing failure types returned by the domain/repository layer.
sealed class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on the server.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not read local data.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The item was not found.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}
