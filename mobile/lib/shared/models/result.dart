import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/errors/failures.dart';

part 'result.freezed.dart';

/// Implementation Plan §17 — the single error-propagation type from `data`
/// through `domain` UseCases to `presentation` controllers.
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = ResultFailure<T>;
}

extension ResultX<T> on Result<T> {
  bool get isSuccess => this is Success<T>;

  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    ResultFailure<T>() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    ResultFailure<T>(:final failure) => failure,
  };
}
