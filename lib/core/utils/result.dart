import '../errors/failures.dart';

/// A lightweight Either-style result type used across the domain layer.
/// Avoids extra dependencies while keeping success/failure handling explicit.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Err<T>;

  /// Fold both branches into a single value.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.data);
    return failure((self as Err<T>).failure);
  }

  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}
