import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:get/get.dart';

class AuthProvider {
  final MyClient _client = Get.find<MyClient>();

  Future<dynamic> login({required Map<String, dynamic> data}) async {
    return _client.clientPost(auth: false, data: data, apiRoute: "/login");
  }

  Future<dynamic> register({required Map<String, dynamic> data}) async {
    return _client.clientPost(auth: false, data: data, apiRoute: "/register");
  }

  Future<dynamic> logout() async {
    return _client.clientPost(auth: true, data: {}, apiRoute: "/logout");
  }

  Future<dynamic> user() async {
    return _client.clientGet(auth: true, apiRoute: "/user");
  }
}
