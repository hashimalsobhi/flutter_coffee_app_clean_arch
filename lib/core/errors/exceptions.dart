class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'Unable to connect to the coffee server. Please check your internet connection.',
  });

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}
