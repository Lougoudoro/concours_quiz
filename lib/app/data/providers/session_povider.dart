import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:get/get.dart';

class SessionProvider
{
    final MyClient _client = Get.find<MyClient>();

  String resource='academic-sessions';
  bool auth=true;

  Future<dynamic> selectedSession() async {
    return  await  _client.clientGet(auth:auth,apiRoute: "/$resource/my-selected-session");
  }
}
