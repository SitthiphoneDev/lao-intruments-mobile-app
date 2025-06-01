// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:lao_instruments/DI/service_locator.dart';

class IntercepterService {
  // Private constructor
  IntercepterService._privateConstructor();

  // Static instance of the class
  static final IntercepterService _instance =
      IntercepterService._privateConstructor();

  // Getter to access the instance
  static IntercepterService get instance => _instance;

  // ANSI color codes for beautiful logging
  static const String _resetColor = '\x1B[0m';
  static const String _yellowColor = '\x1B[33m';
  static const String _greenColor = '\x1B[32m';
  static const String _blueColor = '\x1B[34m';
  static const String _redColor = '\x1B[31m';
  static const String _cyanColor = '\x1B[36m';

  /// Returns an [InterceptorsWrapper] that can be added to a Dio instance.
  InterceptorsWrapper initialInterceptors() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Check if we have authentication service available
        final authService = _getAuthService();
        final token = authService?.getAccessToken();

        // Add token to header if available
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = "Bearer $token";
        }

        // Create beautiful log messages
        _logRequest(options, token);

        handler.next(options);
      },

      onResponse: (response, handler) {
        _logResponse(response);
        handler.next(response);
      },

      onError: (error, handler) async {
        _logError(error);

        // Handle authentication errors if auth service is available
        final authService = _getAuthService();
        if (authService != null &&
            (error.response?.statusCode == 401 ||
                error.response?.statusCode == 403)) {
          try {
            final newToken = await authService.refreshToken();
            if (newToken != null && newToken.isNotEmpty) {
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newToken';
              final retryResponse = await _retryRequest(error.requestOptions);
              return handler.resolve(retryResponse);
            }
          } catch (e) {
            developer.log('${_redColor}Refresh token failed: $e${_resetColor}');
          }
        }

        handler.next(error);
      },
    );
  }

  /// Retries a failed request with updated request options.
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final dio = getIt<Dio>();
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
        responseType: requestOptions.responseType,
      ),
    );
  }

  /// Logs request details in a beautifully formatted way.
  void _logRequest(RequestOptions options, String? token) {
    final method = options.method.toUpperCase();
    final endpoint = options.uri.toString();
    final headers = options.headers.toString();
    final data = options.data?.toString() ?? 'No data';

    final methodColor = _getMethodColor(method);

    developer.log(
      '${_cyanColor}┌────────────────── REQUEST ──────────────────${_resetColor}',
    );
    developer.log(
      '${_cyanColor}│ ${methodColor}$method${_resetColor} ${_yellowColor}$endpoint${_resetColor}',
    );
    developer.log(
      '${_cyanColor}│ Headers: ${_blueColor}$headers${_resetColor}',
    );

    if (token != null) {
      final maskedToken = _maskToken(token);
      developer.log(
        '${_cyanColor}│ Auth: ${_greenColor}Bearer $maskedToken${_resetColor}',
      );
    } else {
      developer.log(
        '${_cyanColor}│ Auth: ${_yellowColor}No token provided${_resetColor}',
      );
    }

    developer.log('${_cyanColor}│ Body: ${_blueColor}$data${_resetColor}');
    developer.log(
      '${_cyanColor}└─────────────────────────────────────────────${_resetColor}',
    );
  }

  /// Logs response details in a beautifully formatted way.
  void _logResponse(Response response) {
    final statusCode = response.statusCode;
    final endpoint = response.requestOptions.uri.toString();
    final data = response.data?.toString() ?? 'No data';

    final statusColor = _getStatusCodeColor(statusCode ?? 0);

    developer.log(
      '${_greenColor}┌────────────────── RESPONSE ─────────────────${_resetColor}',
    );
    developer.log(
      '${_greenColor}│ ${statusColor}$statusCode${_resetColor} ${_yellowColor}$endpoint${_resetColor}',
    );
    developer.log('${_greenColor}│ Data: ${_blueColor}$data${_resetColor}');
    developer.log(
      '${_greenColor}└─────────────────────────────────────────────${_resetColor}',
    );
  }

  /// Logs error details in a beautifully formatted way.
  void _logError(DioException error) {
    final statusCode = error.response?.statusCode;
    final endpoint = error.requestOptions.uri.toString();
    final errorMessage = error.message ?? 'Unknown error';
    final errorData = error.response?.data?.toString() ?? 'No error data';

    developer.log(
      '${_redColor}┌────────────────── ERROR ────────────────────${_resetColor}',
    );
    developer.log(
      '${_redColor}│ ${_yellowColor}$statusCode${_resetColor} ${_redColor}$endpoint${_resetColor}',
    );
    developer.log(
      '${_redColor}│ Message: ${_yellowColor}$errorMessage${_resetColor}',
    );
    developer.log(
      '${_redColor}│ Data: ${_yellowColor}$errorData${_resetColor}',
    );
    developer.log(
      '${_redColor}└─────────────────────────────────────────────${_resetColor}',
    );
  }

  /// Returns the appropriate color for an HTTP method.
  String _getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return '\x1B[32m'; // Green
      case 'POST':
        return '\x1B[33m'; // Yellow
      case 'PUT':
        return '\x1B[34m'; // Blue
      case 'DELETE':
        return '\x1B[31m'; // Red
      case 'PATCH':
        return '\x1B[35m'; // Magenta
      default:
        return '\x1B[37m'; // White
    }
  }

  /// Returns the appropriate color for an HTTP status code.
  String _getStatusCodeColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return '\x1B[32m'; // Green
    if (statusCode >= 300 && statusCode < 400) return '\x1B[34m'; // Blue
    if (statusCode >= 400 && statusCode < 500) return '\x1B[33m'; // Yellow
    if (statusCode >= 500) return '\x1B[31m'; // Red
    return '\x1B[37m'; // White
  }

  /// Masks a token for secure logging.
  String _maskToken(String token) {
    if (token.length <= 8) return '****';
    return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
  }

  /// Gets the authentication service if available. Return null if not available.
  dynamic _getAuthService() {
    try {
      // Try to get auth service from your DI
      // If not available or you don't have auth yet, this will return null
      // Replace with your actual auth service type
      // return getIt<AuthService>();
      return null;
    } catch (e) {
      return null;
    }
  }
}
