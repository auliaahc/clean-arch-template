import 'package:freezed_annotation/freezed_annotation.dart';

part 'meta_dto.freezed.dart';
part 'meta_dto.g.dart';

@freezed
abstract class MetaDto with _$MetaDto {
  const factory MetaDto({PaginationDto? pagination}) = _MetaDto;

  factory MetaDto.fromJson(Map<String, dynamic> json) =>
      _$MetaDtoFromJson(json);
}

@freezed
abstract class PaginationDto with _$PaginationDto {
  const factory PaginationDto({
    required int page,
    required int pageSize,
    required int pageCount,
    required int total,
  }) = _PaginationDto;

  factory PaginationDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationDtoFromJson(json);
}
