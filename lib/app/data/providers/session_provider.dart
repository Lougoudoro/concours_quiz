import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:get/get.dart';

class SessionProvider
{
    final MyClient _client = Get.find<MyClient>();

  String resource='academic-sessions';

  Future<dynamic> selectedSession() async {
    return  await  _client.clientGet(apiRoute: "/$resource/my-selected-session");
  }
}
