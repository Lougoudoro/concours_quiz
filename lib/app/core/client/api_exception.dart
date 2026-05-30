import 'app_exception.dart';

class ApiException extends AppException {
  final int? statusCode;
  final dynamic errors;

  const ApiException({
    super.message,
    super.code,
    this.statusCode,
    this.errors,
    super.originalError,
    super.stackTrace,
  });

  factory ApiException.fromResponseBody(Map body) {
    final status = body['status'] as int?;
    final message = body['message'] as String?;
    final errors = body['errors'];
    final success = body['success'] as bool?;

    if (success == false && status != null) {
      switch (status) {
        case 400:
          return ApiException.badRequest(message: message, errors: errors);
        case 401:
          return ApiException.unauthorized(message: message);
        case 403:
          return ApiException.forbidden(message: message);
        case 404:
          return ApiException.notFound(message: message);
        case 409:
          return ApiException.conflict(message: message);
        case 422:
          return ApiException.validation(message, errors);
        case 429:
          return ApiException.tooManyRequests(message: message);
        default:
      }
    }

    return ApiException(
      message: message ?? 'Erreur serveur',
      code: 'API_ERROR',
      statusCode: status,
      errors: errors,
      originalError: body,
    );
  }

  factory ApiException.badRequest({String? message, dynamic errors}) =>
      ApiException(
        message: message ?? 'Requête invalide',
        code: 'BAD_REQUEST',
        statusCode: 400,
        errors: errors,
      );

  factory ApiException.unauthorized({String? message}) => ApiException(
        message: message??'Session expirée, veuillez vous reconnecter',
        code: 'UNAUTHORIZED',
        statusCode: 401,
      );

  factory ApiException.forbidden({String? message}) => ApiException(
        message: message??'Accès refusé',
        code: 'FORBIDDEN',
        statusCode: 403,
      );

  factory ApiException.notFound({String? message}) => ApiException(
        message: message??'Ressource introuvable',
        code: 'NOT_FOUND',
        statusCode: 404,
      );

  factory ApiException.conflict({String? message}) => ApiException(
        message: message??'Conflit avec les données existantes',
        code: 'CONFLICT',
        statusCode: 409,
      );

  factory ApiException.validation([String? message, dynamic errors]) =>
      ApiException(
        message: message ?? 'Données invalides',
        code: 'VALIDATION_ERROR',
        statusCode: 422,
        errors: errors,
      );

  factory ApiException.tooManyRequests({String? message}) => ApiException(
        message: message?? 'Trop de requêtes, veuillez réessayer plus tard',
        code: 'RATE_LIMIT',
        statusCode: 429,
      );

  factory ApiException.serverError({String? message}) => ApiException(
        message: message??'Erreur interne du serveur',
        code: 'SERVER_ERROR',
        statusCode: 500,
      );

  factory ApiException.serviceUnavailable({String? message}) => ApiException(
        message: message??'Service temporairement indisponible',
        code: 'SERVICE_UNAVAILABLE',
        statusCode: 503,
      );
}
