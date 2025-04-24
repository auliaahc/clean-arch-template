import 'package:clean_arch_template/src/features/contact/data/models/contact_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_state.freezed.dart';

@freezed
abstract class ContactState with _$ContactState {
  const factory ContactState({
    @Default([]) List<ContactModel> contacts,
    ContactModel? detailContact,
    @Default(true) bool isLoading,
    @Default(false) bool isError,
    @Default('') String errorMessage,
  }) = _ContactState;
}