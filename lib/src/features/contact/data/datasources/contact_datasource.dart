import 'package:dartz/dartz.dart';
import 'package:clean_arch_template/src/core/error/app_exception.dart';
import 'package:clean_arch_template/src/features/contact/data/models/contact_model.dart';

abstract class ContactDatasource {
  Future<Either<AppException, List<ContactModel>>> getAll();
}