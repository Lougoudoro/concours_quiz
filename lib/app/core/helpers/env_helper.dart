import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvHelper {
  static String get apiUrl =>
      dotenv.get('API_URL', fallback: 'http://127.0.0.1:8000/api/v1');
  static String get port => dotenv.get('PORT', fallback: '8000');
  static String get host => dotenv.get('HOST', fallback: '127.0.0.1');
}
