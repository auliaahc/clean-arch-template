import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clean_arch_template/src/features/contact/domain/usecases/get_all_contact_usecase.dart';
import 'package:clean_arch_template/src/features/contact/presentation/state/contact_state.dart';

class ContactViewmodel extends StateNotifier<ContactState> {
  final GetAllContactUsecase getAllContactUsecase;
  ContactViewmodel(this.getAllContactUsecase) : super(ContactState());

  Future<void> fetchContacts() async {
    state = state.copyWith(isLoading: true, isError: false, errorMessage: '');
    final result = await getAllContactUsecase.execute();
    result.fold(
      (error) =>
          state = state.copyWith(
            isLoading: false,
            isError: true,
            errorMessage: error.toString(),
          ),
      (contacts) =>
          state = state.copyWith(isLoading: false, contacts: contacts),
    );
  }
}
