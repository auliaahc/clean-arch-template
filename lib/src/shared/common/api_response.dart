import 'package:clean_arch_template/src/core/error/app_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';

@freezed
sealed class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success(T value) = ApiSuccess<T>;
  const factory ApiResponse.error(AppException exception) = ApiError;
}