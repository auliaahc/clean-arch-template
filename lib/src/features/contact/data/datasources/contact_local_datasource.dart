import 'package:dartz/dartz.dart';
import 'package:objectbox/objectbox.dart';
import 'package:clean_arch_template/src/core/error/app_exception.dart';
import 'package:clean_arch_template/src/features/contact/data/database/contact_db.dart';
import 'package:clean_arch_template/src/features/contact/data/datasources/contact_datasource.dart';
import 'package:clean_arch_template/src/features/contact/data/models/contact_model.dart';

class ContactLocalDatasource implements ContactDatasource {
  final Store _store;
  ContactLocalDatasource({required Store store}) : _store = store;

  @override
  Future<Either<AppException, List<ContactModel>>> getAll() async {
    try {
      final box = _store.box<ContactDb>();
      final localContacts = box.getAll();

      if (localContacts.isNotEmpty) {
        return Right(localContacts.map((e) => e.toModel()).toList());
      } else {
        return Left(AppException.errorWithMessage('No local data found'));
      }
    } catch (e) {
      return Left(AppException.errorWithMessage(e.toString()));
    }
  }

  Future<void> saveContactsToLocal(List<ContactModel> contacts) async {
    final box = _store.box<ContactDb>();
    final contactDbs =
        contacts
            .map(
              (e) => ContactDb(
                id: 0,
                remoteId: e.id,
                firstName: e.firstName,
                lastName: e.lastName,
                email: e.email,
                avatar: e.avatar,
              ),
            )
            .toList();
    box.putMany(contactDbs);
  }
}
