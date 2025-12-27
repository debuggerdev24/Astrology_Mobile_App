import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../apps/mobile/user/services/settings/locale_storage_service.dart';
import '../constants/app_config.dart';
import '../utils/logger.dart';
import 'end_points.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;
  factory DioClient() => _instance;
  DioClient._internal() {
    final baseOptions = BaseOptions(baseUrl: AppConfig.apiBaseurl);
    dio = Dio(baseOptions);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = LocaleStoaregService.userToken;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
    dio.interceptors.addAll([
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);
  }
}

class BaseApiHelper {
  BaseApiHelper._();
  String get token_not_valid => "token_not_valid";
  static final BaseApiHelper _instance = BaseApiHelper._();
  static BaseApiHelper get instance => _instance;
  final Dio _dio = DioClient().dio;
  Future<Either<ApiException, T>> get<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final mergedQueryParams = {
        "lang": LocaleStoaregService.localeCode,
        ...?queryParameters, // spread only if not null
      };
      final response = await _dio.get(
        path,
        queryParameters: mergedQueryParams,
        options: options,
      );
      // final result = _handleResponse(response);
      final result = response.data;
      if (parser != null) {
        return Right(parser(result));
      } else {
        return Right(result as T);
      }
    } on DioException catch (e) {
      return Left(
        ApiException(
          _handleErrorMessage(e),
          code: e.response?.statusCode.toString(),
          originalErrorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      return Left(
        ApiException(
          'Somethign went wrong',
          originalErrorMessage: e.toString(),
          code: '',
        ),
      );
    }
  }

  Future<Either<ApiException, T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final mergedQueryParams = {
        "lang": LocaleStoaregService.localeCode,
        ...?queryParameters, // spread only if not null
      };
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: mergedQueryParams,
        options: options,
      );
      final result = response.data;
      if (parser != null) {
        return Right(parser(result));
      } else {
        return Right(result as T);
      }
    } on DioException catch (e) {
      // Fallback for other errors
      return Left(
        ApiException(
          _handleErrorMessage(e),
          code: e.response?.statusCode.toString(),
          originalErrorMessage: e.message,
        ),
      );
    } catch (e) {
      Logger.printError(":x: Exception: $e");
      return Left(
        ApiException(
          'Something went wrong',
          code: '',
          originalErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<Either<ApiException, T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final mergedQueryParams = {
        "lang": LocaleStoaregService.localeCode,
        ...?queryParameters, // spread only if not null
      };
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: mergedQueryParams,
        options: options,
      );
      final result = response.data;
      if (parser != null) {
        return Right(parser(result));
      } else {
        return Right(result as T);
      }
    } on DioException catch (e) {
      return Left(
        ApiException(
          _handleErrorMessage(e),
          code: e.response?.statusCode.toString(),
          originalErrorMessage: e.message,
        ),
      );
    } catch (e) {
      Logger.printError(":x: Exception: $e");
      return Left(
        ApiException(
          'Something went wrong',
          code: '',
          originalErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<Either<ApiException, T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final mergedQueryParams = {
        "lang": LocaleStoaregService.localeCode,
        ...?queryParameters, // spread only if not null
      };
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: mergedQueryParams,
        options: options,
      );
      final result = response.data;
      if (parser != null) {
        return Right(parser(result));
      } else {
        return Right(result as T);
      }
    } on DioException catch (e) {
      return Left(
        ApiException(
          _handleErrorMessage(e),
          code: e.response?.statusCode.toString(),
          originalErrorMessage: e.message,
        ),
      );
    } catch (e) {
      Logger.printError(":x: Exception: $e");
      return Left(
        ApiException(
          'Something went wrong',
          code: '',
          originalErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<Either<ApiException, bool>> checkTokenExpired() async {
    try {
      final response = await _dio.get(Endpoints.checkTokenExpired);
      final result = response.data;
      Logger.printInfo(
        "inside try section -> ${result["messages"].toString()}",
      );
      if (result['details'] == "token_not_valid") {
        return Right(true);
      } else {
        return Right(false);
      }
    } on DioException catch (e) {
      return Right(false);
    } catch (e) {
      Logger.printError(":x: Exception: $e");
      return Right(false);
    }
  }

  Future<Either<ApiException, void>> refreshAuthToken() async {
    Logger.printInfo(
      "refresh auth token : ${LocaleStoaregService.userRefreshToken}",
    );
    var data = FormData.fromMap({
      'refresh': LocaleStoaregService.userRefreshToken,
    });
    try {
      final response = await _dio.post(Endpoints.refreshToken, data: data);
      final result = response.data;
      if (result["code"] == token_not_valid) {
        return Left(
          ApiException(
            'Token is expired',
            code: '0',
            originalErrorMessage: 'Token is expired',
          ),
        );
      } else {
        final newToken = result["access"];
        await LocaleStoaregService.saveUserToken(newToken);
      }
      return Right(null);
    } on DioException catch (e) {
      return Left(
        ApiException(
          _handleErrorMessage(e),
          code: e.response!.data["code"],
          originalErrorMessage: e.message,
        ),
      );
    } catch (e) {
      Logger.printError(":x: Exception: $e");
      return Left(
        ApiException(
          'Something went wrong',
          code: '',
          originalErrorMessage: e.toString(),
        ),
      );
    }
  }

  String _handleErrorMessage(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timed out';
    }
    if (e.type == DioExceptionType.receiveTimeout) {
      return 'Receive timeout';
    }
    if (e.response != null) {
      final data = e.response?.data;
      if (e.response?.statusCode == 400) {
        if (data is Map) {
          final errorContent = data['error'] ?? data['errors'];
          // If we found 'error' or 'errors' and it's a map
          if (errorContent is Map && errorContent.isNotEmpty) {
            final firstKey = errorContent.keys.first;
            Logger.printInfo("[Base Api Helper] --- first key: $firstKey");
            final errorValue = errorContent[firstKey];
            if (errorValue is List && errorValue.isNotEmpty) {
              return errorValue.first.toString();
            } else if (errorValue is String) {
              return errorValue;
            }
          }
          // If 'message' exists
          if (data.containsKey('message')) {
            return data['message'].toString();
          }
          // Try generic key-based parsing (Django/DRF style)
          final firstKey = data.keys.firstOrNull;
          final errorList = data[firstKey];
          if (errorList is List && errorList.isNotEmpty) {
            return errorList.first.toString();
          }
        } else if (data is String) {
          return data;
        }
        return 'Invalid request (400)';
      } else if (e.response?.statusCode == 401) {
        return 'Unauthorized. Please log in again.';
      }
      return data[1] ?? 'Unexpected server response';
    }
    return e.message ?? 'Unknown error occurred';
  }
}

class ApiException implements Exception {
  final String errorMessage;
  final String? code;
  final String? originalErrorMessage;
  ApiException(
    this.errorMessage, {
    required this.code,
    this.originalErrorMessage,
  });
  @override
  String toString() {
    return "api error: $errorMessage ----- status code: $code";
  }
}

/*
access token:
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUyNzE2ODUyLCJpYXQiOjE3NTI2NDQ4NTIsImp0aSI6IjJkOTM4OTQxZDEwOTQ2ZWZiYjM1YWE5YTNiYWVkOTg4IiwidXNlcl9pZCI6MTN9.7k5a91to_THU7FiouUregFJicqMjgqY_sOWoZNYXZWM
Refresh token:
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTc1MjczMTI1MiwiaWF0IjoxNzUyNjQ0ODUyLCJqdGkiOiIwMjlhNjNkOGRjMzI0OGQxOTA4NTU2ZDczMThmZGEyMSIsInVzZXJfaWQiOjEzfQ.TvKO7LbCEge4iXyIMjKNoaBVOkyMd5BVYBWNmkC3LQc
*/
