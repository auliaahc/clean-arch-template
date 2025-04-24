import 'package:clean_arch_template/src/core/error/app_exception.dart';
import 'package:clean_arch_template/src/features/contact/data/models/contact_model.dart';
import 'package:dartz/dartz.dart';

abstract class ContactRepository {
  Future<Either<AppException, List<ContactModel>>> getAll();
}