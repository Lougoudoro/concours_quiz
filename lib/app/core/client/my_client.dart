import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import 'package:cncours_quiz/app/data/models/token.dart';
import 'api_exception.dart';
import 'app_exception.dart';
import '../helpers/env_helper.dart';

class MyClient extends GetConnect {
  static const int timeOutDuration = 5;

  @override
  void onInit() {
    // Set your base URL and internal GetX timeout globally
    httpClient.baseUrl = EnvHelper.apiUrl;
    httpClient.timeout = const Duration(seconds: timeOutDuration);

    httpClient.addRequestModifier<dynamic>((request) {
      // Automatically attach global JSON headers
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';

      final token = Token.get();
      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
    
    super.onInit();
  }

  Future<dynamic> clientGet({
    bool auth = true,
    required String apiRoute,
  }) async {
    final response = await get(apiRoute);
    return processResponse(response);
  }

  Future<dynamic> clientDelete({
  bool auth = true,
    required String apiRoute,
  }) async {
    final response = await delete(apiRoute);
    return processResponse(response);
  }

  Future<dynamic> clientPut({
    required bool auth,
    Map<String, dynamic> data = const {},
    required String apiRoute,
  }) async {
    final response = await put(apiRoute,jsonEncode(data),
    );
    return processResponse(response);
  }

  Future<dynamic> clientPost({
    required bool auth,
    required Map<String, dynamic> data,
    required String apiRoute,
  }) async {
    final response = await post(
      apiRoute,
      jsonEncode(data),
    );
    return processResponse(response);
  }

  /// Processes the API response.
  /// Throws [NetworkException] or standard exceptions when connection drops.
  /// Throws [ApiException] when HTTP status is non-2xx or custom server errors occur.
  dynamic processResponse(Response response) {
  if (response.status.hasError) {
    
    // Check for a literal Timeout first
    final String errorText = response.statusText?.toLowerCase() ?? '';
    if (errorText.contains('timed out')) {
      throw const TimeoutException();
    }
    
    // If it's not a timeout, but still a connection error, it's a Socket issue
    if (response.status.connectionError) {
      throw const NetworkException(); // Represents your SocketException (Host unreachable/No internet)
    }
  }

    final body = response.body;

    // 2. Read status code (GetX extracts this directly into response.statusCode)
    final int? statusCode = response.statusCode;
    
    if (statusCode == null) {
      throw ApiException(
        message: 'Réponse invalide du serveur',
        code: 'NO_STATUS_CODE',
        originalError: response,
      );
    }

    // 3. Evaluate success (2xx HTTP status codes)
    if (statusCode >= 200 && statusCode < 300) {
      if (body is Map && body['success'] == false) {
        throw ApiException(
          message: body['message'] as String? ?? 'Erreur',
          code: 'API_ERROR',
          statusCode: body['status'] as int?,
          errors: body['errors'],
          originalError: body,
        );
      }
      return body;
    }

    // 4. Any other non-2xx response status falls back to your custom error mapper
    throw ApiException.fromResponseBody(body);
  }
}