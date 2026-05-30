/// Base application exception with structured information for UI display
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    this.message = 'Une erreur est survenue',
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => '[$code] $message';
}

/// Network / connectivity exceptions
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Problème de connexion réseau',
    super.code = 'NETWORK_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Server did not respond in time
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Le serveur ne répond pas',
    super.code = 'TIMEOUT',
    super.originalError,
    super.stackTrace,
  });
}

/// Data parsing / serialization errors
class DataParsingException extends AppException {
  const DataParsingException({
    super.message = 'Erreur de lecture des données',
    super.code = 'PARSE_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Generic unknown / unexpected errors
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Une erreur inattendue est survenue',
    super.code = 'UNKNOWN',
    super.originalError,
    super.stackTrace,
  });
}
