import 'package:dartz/dartz.dart';
import 'package:clean_arch_template/src/core/error/app_exception.dart';
import 'package:clean_arch_template/src/core/http/dio_provider.dart';
import 'package:clean_arch_template/src/features/contact/data/datasources/contact_datasource.dart';
import 'package:clean_arch_template/src/features/contact/data/dto/contact_dto.dart';
import 'package:clean_arch_template/src/features/contact/data/models/contact_model.dart';
import 'package:clean_arch_template/src/shared/common/api_response.dart';

class ContactRemoteDatasource implements ContactDatasource {
  final DioProvider _api;
  ContactRemoteDatasource(this._api);

  @override
  Future<Either<AppException, List<ContactModel>>> getAll() async {
    final response = await _api.get('/contacts');
    switch (response) {
      case ApiSuccess(:final value):
        final responseDto = ContactDto.fromJson(value as Map<String, dynamic>);
        final contacts = responseDto.data.map((e) => e.toModel()).toList();
        return Right(contacts);
      case ApiError(:final exception):
        return Left(exception);
    }
  }
}
