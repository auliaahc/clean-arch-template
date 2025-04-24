import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_dto.freezed.dart';
part 'error_dto.g.dart';

@freezed
abstract class ErrorResponseDto with _$ErrorResponseDto {
  const factory ErrorResponseDto({
    required dynamic data,
    required ErrorDto error,
  }) = _ErrorResponseDto;

  factory ErrorResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseDtoFromJson(json);
}

@freezed
abstract class ErrorDto with _$ErrorDto {
  const factory ErrorDto({
    required int status,
    required String name,
    required String message,
    required ErrorDetailDto details,
  }) = _ErrorDto;

  factory ErrorDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorDtoFromJson(json);
}

@freezed
abstract class ErrorDetailDto with _$ErrorDetailDto {
  factory ErrorDetailDto() = _ErrorDetailDto;
  factory ErrorDetailDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorDetailDtoFromJson(json);
}
