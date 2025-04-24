import 'package:clean_arch_template/src/features/contact/data/datasources/contact_local_datasource.dart';
import 'package:clean_arch_template/src/features/contact/data/datasources/contact_remote_datasource.dart';
import 'package:clean_arch_template/src/features/contact/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:clean_arch_template/src/core/error/app_exception.dart';
import 'package:clean_arch_template/src/features/contact/data/models/contact_model.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDatasource _remoteDatasource;
  final ContactLocalDatasource _localDatasource;

  ContactRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<Either<AppException, List<ContactModel>>> getAll() async {
    final result = await _remoteDatasource.getAll();
    return await result.fold(
      (error) async {
        return await _localDatasource.getAll();
      },
      (contacts) async {
        await _localDatasource.saveContactsToLocal(contacts);
        return Right(contacts);
      },
    );
  }
}
