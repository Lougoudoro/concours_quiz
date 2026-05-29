import 'package:cncours_quiz/app/core/client/my_client.dart';

class SessionProvider extends MyClient
{
  String resource='academic-sessions';
  bool auth=true;

  Future<dynamic> selectedSession() async {
    return  await clientGet(auth:auth,apiRoute: "/$resource/my-selected-session");
  }
}
