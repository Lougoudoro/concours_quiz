import 'dart:io';
import 'package:cncours_quiz/app/core/client/my_client.dart';

class AuthProvider extends MyClient {
  Future<dynamic> login({required Map<String, dynamic> data}) async {
    try {
      var response =
          await clientPost(auth: false, data: data, apiRoute: "/login");
      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> register({required Map<String, dynamic> data}) async {
    try {
      var response =
          await clientPost(auth: false, data: data, apiRoute: "/register");
      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> logout() async {
    try {
      var response =
          await clientPost(auth: true, data: {}, apiRoute: "/logout");
      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> user() async {
    try {
      var response = await clientGet(auth: true, apiRoute: "/user");
      return response;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
