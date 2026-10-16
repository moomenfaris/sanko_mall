import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

/// Thin wrapper around [Dio] preconfigured for the Sanko Mall backend.
/// Centralises base URL, timeouts, and auth-token injection so switching
/// from mock data to a real backend only touches this file + repositories.
class ApiClient {
  ApiClient({Dio? dio, String? Function()? tokenProvider})
    : _tokenProvider = tokenProvider,
      dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConstants.baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              contentType: 'application/json',
            ),
          ) {
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenProvider?.call();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio dio;
  final String? Function()? _tokenProvider;
}
