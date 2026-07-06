import 'package:dio/dio.dart';
import 'package:doctro/retrofit/apis.dart';
import 'package:flutter/foundation.dart';

class AstraApiClient {
  late final Dio _dio;

  AstraApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: Apis.astraBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  static final AstraApiClient _instance = AstraApiClient._internal();

  static AstraApiClient get instance => _instance;

  Dio get dio => _dio;

  // Add authentication token
  void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear authentication token
  void clearToken() {
    _dio.options.headers.remove('Authorization');
  }
}
