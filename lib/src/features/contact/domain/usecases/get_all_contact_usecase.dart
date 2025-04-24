import 'package:dartz/dartz.dart';
import 'package:clean_arch_template/src/core/error/app_exception.dart';
import 'package:clean_arch_template/src/features/contact/data/models/contact_model.dart';
import 'package:clean_arch_template/src/features/contact/domain/repositories/contact_repository.dart';

class GetAllContactUsecase {
  final ContactRepository repository;
  GetAllContactUsecase(this.repository);

  Future<Either<AppException, List<ContactModel>>> execute() =>
      repository.getAll();
}
