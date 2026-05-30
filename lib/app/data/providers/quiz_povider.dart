import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:get/get.dart';

class QuizProvider
{
  final MyClient _client = Get.find<MyClient>();

  String resource='quizzes';
  bool auth=true;

  Future<dynamic> questions({ required String id}) async {
    return  await  _client.clientGet(auth:auth,apiRoute: "/$resource/$id/questions");
  }
}
