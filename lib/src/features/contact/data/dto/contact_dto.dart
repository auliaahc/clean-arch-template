import 'package:clean_arch_template/src/features/contact/data/models/contact_model.dart';
import 'package:clean_arch_template/src/shared/common/dto/meta_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_dto.freezed.dart';
part 'contact_dto.g.dart';

@freezed
abstract class ContactDto with _$ContactDto {
  const factory ContactDto({
    required List<DataDto> data,
    required MetaDto meta,
  }) = _ContactDto;

  factory ContactDto.fromJson(Map<String, dynamic> json) =>
      _$ContactDtoFromJson(json);
}

@freezed
abstract class DetailContactDto with _$DetailContactDto {
  const factory DetailContactDto({
    required DataDto data,
    required MetaDto meta,
  }) = _DetailContactDto;

  factory DetailContactDto.fromJson(Map<String, dynamic> json) =>
      _$DetailContactDtoFromJson(json);
}

@freezed
abstract class DataDto with _$DataDto {
  const factory DataDto({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String avatar,
  }) = _DataDto;

  const DataDto._();

  ContactModel toModel() => ContactModel(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    avatar: avatar,
  );

  factory DataDto.fromJson(Map<String, dynamic> json) =>
      _$DataDtoFromJson(json);
}
