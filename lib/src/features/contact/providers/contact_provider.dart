import 'package:clean_arch_template/src/core/database/database_helper.dart';
import 'package:clean_arch_template/src/features/contact/data/datasources/contact_local_datasource.dart';
import 'package:clean_arch_template/src/features/contact/presentation/state/contact_state.dart';
import 'package:clean_arch_template/src/features/contact/presentation/viewmodel/contact_viewmodel.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:clean_arch_template/src/features/contact/domain/usecases/get_all_contact_usecase.dart';
import 'package:clean_arch_template/src/features/contact/domain/repositories/contact_repository.dart';
import 'package:clean_arch_template/src/features/contact/data/repositories/contact_repository_impl.dart';
import 'package:clean_arch_template/src/features/contact/data/datasources/contact_remote_datasource.dart';
import 'package:clean_arch_template/src/core/http/dio_provider.dart';
import 'package:clean_arch_template/src/core/api/endpoint.dart';


final contactRemoteDatasourceProvider = Provider<ContactRemoteDatasource>((ref) {
  final api = ref.watch(dioProvider(Endpoint.baseUrl));
  return ContactRemoteDatasource(api);
});

final contactLocalDatasourceProvider = Provider<ContactLocalDatasource>((ref) {
  final store = ref
      .watch(databaseHelperProvider)
      .maybeWhen(
        data: (db) => db.store,
        orElse: () => throw Exception("Database belum siap"),
      );
  return ContactLocalDatasource(store: store);
});

final contactRepositoryProvider = Provider<ContactRepository>((ref) {
  final remote = ref.watch(contactRemoteDatasourceProvider);
  final local = ref.watch(contactLocalDatasourceProvider);
  return ContactRepositoryImpl(
    remote,
    local,
  );
});

final getAllContactUsecaseProvider = Provider<GetAllContactUsecase>((ref) {
  final repository = ref.watch(contactRepositoryProvider);
  return GetAllContactUsecase(repository);
});

final contactViewmodelProvider = StateNotifierProvider<ContactViewmodel, ContactState>((ref) {
  final usecase = ref.watch(getAllContactUsecaseProvider);
  return ContactViewmodel(usecase);
});