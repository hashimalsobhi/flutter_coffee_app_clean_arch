import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class NetworkClient {
  final http.Client _client;
  final RetryOptions _retryOptions;

  NetworkClient({
    http.Client? client,
    RetryOptions? retryOptions,
  })  : _client = client ?? http.Client(),
        _retryOptions = retryOptions ??
            const RetryOptions(
              maxAttempts: ApiConstants.maxRetryAttempts,
              delayFactor: ApiConstants.retryInitialDelay,
            );

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(endpoint, queryParameters);

    try {
      final response = await _retryOptions.retry(
        () => _client
            .get(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                ...?headers,
              },
            )
            .timeout(ApiConstants.connectTimeout),
        retryIf: (e) =>
            e is SocketException ||
            e is TimeoutException ||
            e is http.ClientException,
        onRetry: (e) {
          // Retry triggered on network transient failure
        },
      );

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException(
        message: 'No Internet connection or server unreachable: ${e.message}',
      );
    } on TimeoutException {
      throw const NetworkException(
        message: 'Connection timed out. Retrying failed. Please try again.',
      );
    } on http.ClientException catch (e) {
      throw NetworkException(
        message: 'HTTP client error: ${e.message}',
      );
    }
  }

  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    final fullUrl = '${ApiConstants.baseUrl}$cleanEndpoint';
    
    if (queryParameters == null || queryParameters.isEmpty) {
      return Uri.parse(fullUrl);
    }

    // Convert values to string
    final stringParams = queryParameters.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    return Uri.parse(fullUrl).replace(queryParameters: stringParams);
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return json.decode(response.body);
      } catch (e) {
        throw ServerException(
          statusCode: statusCode,
          message: 'Failed to decode JSON response: $e',
        );
      }
    } else if (statusCode == 404) {
      throw ServerException(
        statusCode: statusCode,
        message: 'Requested coffee resource not found (404)',
      );
    } else {
      throw ServerException(
        statusCode: statusCode,
        message: 'Server error with status code $statusCode: ${response.body}',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
