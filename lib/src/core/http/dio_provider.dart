import 'dart:io';
import 'package:clean_arch_template/src/core/error/app_exception.dart';
import 'package:clean_arch_template/src/shared/common/api_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

enum ContentType { urlEncoded, json, formData }

enum HttpMethod { get, post, put, patch, delete }

final dioProvider = Provider.family<DioProvider, String>((ref, setBaseUrl) {
  return DioProvider(setBaseUrl);
});

class DioProvider {
  final String _baseUrl;
  late final Dio _dio;

  DioProvider(this._baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
        sendTimeout: Duration(seconds: 10),
      ),
    );
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(requestBody: true));
    }
  }

  Future<ApiResponse> _request({
    required HttpMethod method,
    required String path,
    dynamic body,
    String? token,
    String? newBaseUrl,
    Map<String, dynamic>? query,
    ContentType contentType = ContentType.json,
  }) async {
    final isConnected = await Connectivity().checkConnectivity();
    if (isConnected.contains(ConnectivityResult.none)) {
      return const ApiResponse.error(AppException.connectivity());
    }
    final headers = _getHeaders(token, contentType);
    final url = (newBaseUrl ?? _baseUrl) + path;
    try {
      final options = Options(
        method: method.name,
        headers: headers,
        validateStatus: (_) => true,
      );
      dynamic requestBody = body;
      if (contentType == ContentType.formData && body is Map<String, dynamic>) {
        requestBody = FormData.fromMap(body);
      }
      late Response response;
      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(
            url,
            queryParameters: query,
            options: options,
          );
          break;
        case HttpMethod.post:
          response = await _dio.post(
            url,
            data: requestBody,
            queryParameters: query,
            options: options,
          );
          break;
        case HttpMethod.put:
          response = await _dio.put(
            url,
            data: requestBody,
            queryParameters: query,
            options: options,
          );
          break;
        case HttpMethod.patch:
          response = await _dio.patch(
            url,
            data: requestBody,
            queryParameters: query,
            options: options,
          );
          break;
        case HttpMethod.delete:
          response = await _dio.delete(
            url,
            queryParameters: query,
            options: options,
          );
          break;
      }
      return _handleResponse(response);
    } on DioException catch (e) {
      if (e.error is SocketException) {
        return const ApiResponse.error(AppException.connectivity());
      }
      return ApiResponse.error(AppException.errorWithMessage(e.message ?? ''));
    } catch (e, stackTrace) {
      return ApiResponse.error(
        AppException.errorWithMessage(stackTrace.toString()),
      );
    }
  }

  Map<String, dynamic> _getHeaders(String? token, ContentType contentType) {
    late String contentTypeValue;
    switch (contentType) {
      case ContentType.urlEncoded:
        contentTypeValue = 'application/x-www-form-urlencoded';
        break;
      case ContentType.json:
        contentTypeValue = 'application/json';
        break;
      case ContentType.formData:
        contentTypeValue = 'multipart/form-data';
        break;
    }
    return {
      'accept': '*/*',
      'Content-Type': contentTypeValue,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }


  ApiResponse _handleResponse(Response response) {
    final status = response.statusCode ?? 500;
    final data = response.data;

    if (status < 300) {
      return ApiResponse.success(data);
    } else if (status == 401) {
      return const ApiResponse.error(AppException.unauthorized());
    } else if (status == 429) {
      return ApiResponse.error(
        AppException.errorWithMessage('Please try again later'),
      );
    } else {
      return const ApiResponse.error(AppException.error());
    }
  }

  Future<ApiResponse> get(
    String path, {
    String? newBaseUrl,
    String? token,
    Map<String, dynamic>? query,
    ContentType contentType = ContentType.json,
  }) async => _request(
    method: HttpMethod.get,
    path: path,
    token: token,
    query: query,
    contentType: contentType,
    newBaseUrl: newBaseUrl,
  );

  Future<ApiResponse> post(
    String path,
    dynamic body, {
    String? newBaseUrl,
    String? token,
    Map<String, dynamic>? query,
    ContentType contentType = ContentType.json,
  }) async => _request(
    method: HttpMethod.post,
    path: path,
    body: body,
    newBaseUrl: newBaseUrl,
    token: token,
    query: query,
    contentType: contentType,
  );

  Future<ApiResponse> put(
    String path,
    dynamic body, {
    String? newBaseUrl,
    String? token,
    Map<String, dynamic>? query,
    ContentType contentType = ContentType.json,
  }) async => _request(
    method: HttpMethod.put,
    path: path,
    body: body,
    newBaseUrl: newBaseUrl,
    token: token,
    query: query,
    contentType: contentType,
  );

  Future<ApiResponse> patch(
    String path,
    dynamic body, {
    String? newBaseUrl,
    String? token,
    Map<String, dynamic>? query,
    ContentType contentType = ContentType.json,
  }) async => _request(
    method: HttpMethod.patch,
    path: path,
    body: body,
    newBaseUrl: newBaseUrl,
    token: token,
    query: query,
    contentType: contentType,
  );

  Future<ApiResponse> delete(
    String path, {
    String? newBaseUrl,
    String? token,
    Map<String, dynamic>? query,
    ContentType contentType = ContentType.json,
  }) async => _request(
    method: HttpMethod.delete,
    path: path,
    newBaseUrl: newBaseUrl,
    token: token,
    query: query,
    contentType: contentType,
  );
}
