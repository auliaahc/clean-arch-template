import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_model.freezed.dart';

@freezed
abstract class ContactModel with _$ContactModel {
  const factory ContactModel({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String avatar,
  }) = _ContactModel;

  const ContactModel._();

  Map<String, dynamic> toRequest() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatar': avatar
    };
  }
}