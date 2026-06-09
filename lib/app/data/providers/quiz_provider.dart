import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:get/get.dart';

class QuizProvider
{
  final MyClient _client = Get.find<MyClient>();

  String resource='quizzes';

  Future<dynamic> questions({ required int id}) async {
    return  await  _client.clientGet(apiRoute: "/$resource/$id/questions");
  }

  Future<dynamic> submitAttempt({ required int id, required Map<String, dynamic> data}) async {
    return  await  _client.clientPost(apiRoute: "/$resource/$id/attempts", data: data);
  }
}
