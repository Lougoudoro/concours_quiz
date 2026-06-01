import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:get/get.dart';

class SessionProvider {
  final MyClient _client = Get.find<MyClient>();

  String resource = 'academic-sessions';

  Future<dynamic> selectedSession() async {
    return await _client.clientGet(apiRoute: "/$resource/my-selected-session");
  }

  Future<dynamic> brands() async {
    return await _client.clientGet(apiRoute: "/brands");
  }

  Future<dynamic> selectSession(int sessionId) async {
    return await _client.clientPost(
      apiRoute: "/$resource/$sessionId/select",
      data: {},
    );
  }

  Future<dynamic> fetchSessionById(int sessionId) async {
    return await _client.clientGet(apiRoute: "/$resource/$sessionId/show");
  }
}
