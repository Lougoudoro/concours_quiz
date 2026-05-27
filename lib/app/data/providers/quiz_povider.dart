import 'package:cncours_quiz/app/core/client/my_client.dart';

class QuizProvider extends MyClient
{
  String resource='quizzes';
  bool auth=true;

  Future<dynamic> questions({ required String id}) async {
    return  await clientGet(auth:auth,apiRoute: "/$resource/$id/questions");
  }
}
