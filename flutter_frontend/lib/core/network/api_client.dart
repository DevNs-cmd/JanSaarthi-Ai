import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../constants/app_constants.dart';

class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  NetworkException({required this.message, this.statusCode, this.errorCode});

  @override
  String toString() => 'NetworkException: $message (Code: $statusCode)';
}

class ApiResponse<T> {
  final T? data;
  final bool success;
  final NetworkException? error;
  final int? statusCode;

  ApiResponse.success(this.data, this.statusCode)
    : success = true,
      error = null;

  ApiResponse.failure(this.error, this.statusCode)
    : success = false,
      data = null;
}

class NetworkInfo {
  Future<bool> get isConnected async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}

class ApiClient {
  late Dio _dio;
  final NetworkInfo networkInfo;

  ApiClient({required this.networkInfo}) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: kDebugMode,
        responseBody: kDebugMode,
        requestHeader: kDebugMode,
        responseHeader: kDebugMode,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!await networkInfo.isConnected) {
            return handler.reject(
              DioException(
                error: 'No internet connection',
                requestOptions: options,
                type: DioExceptionType.unknown,
              ),
            );
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (DioException e, handler) {
          final errorMessage = _handleError(e);
          handler.reject(
            DioException(
              error: errorMessage,
              requestOptions: e.requestOptions,
              response: e.response,
              type: e.type,
            ),
          );
        },
      ),
    );
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';

      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return 'Bad request. Please check your input.';
          case 401:
            return 'Unauthorized. Please login again.';
          case 403:
            return 'Forbidden. You don\'t have permission to access this resource.';
          case 404:
            return 'Resource not found.';
          case 409:
            return 'Conflict. The request could not be completed due to a conflict.';
          case 429:
            return 'Too many requests. Please try again later.';
          case 500:
            return 'Internal server error. Please try again later.';
          case 502:
            return 'Bad gateway. Please try again later.';
          case 503:
            return 'Service unavailable. Please try again later.';
          default:
            return 'Unknown error occurred. Please try again.';
        }

      case DioExceptionType.cancel:
        return 'Request was cancelled.';

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return 'No internet connection.';
        }
        return 'Unknown error occurred.';

      default:
        return 'Something went wrong. Please try again.';
    }
  }

  Future<ApiResponse<T>> get<T>(
    String baseUrl,
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl$path',
        queryParameters: queryParameters,
        options: options,
      );

      if (response.statusCode == 200) {
        final data = parser != null
            ? parser(response.data)
            : response.data as T;
        return ApiResponse.success(data, response.statusCode);
      } else {
        return ApiResponse.failure(
          NetworkException(
            message: 'HTTP ${response.statusCode}: ${response.statusMessage}',
            statusCode: response.statusCode,
          ),
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.failure(
        NetworkException(
          message: e.error.toString(),
          statusCode: e.response?.statusCode,
          errorCode: e.type.toString(),
        ),
        e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<T>> post<T>(
    String baseUrl,
    String path,
    dynamic data, {
    Options? options,
    Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl$path',
        data: data,
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = parser != null
            ? parser(response.data)
            : response.data as T;
        return ApiResponse.success(responseData, response.statusCode);
      } else {
        return ApiResponse.failure(
          NetworkException(
            message: 'HTTP ${response.statusCode}: ${response.statusMessage}',
            statusCode: response.statusCode,
          ),
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.failure(
        NetworkException(
          message: e.error.toString(),
          statusCode: e.response?.statusCode,
          errorCode: e.type.toString(),
        ),
        e.response?.statusCode,
      );
    }
  }

  void addAuthHeader(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthHeader() {
    _dio.options.headers.remove('Authorization');
  }
}
