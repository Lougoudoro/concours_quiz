import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:get/get.dart';

class QuestionReportProvider {
  final MyClient _client = Get.find<MyClient>();

  Future<dynamic> report(
      {required int questionId, required String message}) async {
    return await _client.clientPost(
      apiRoute: "/questions/$questionId/report",
      data: {'message': message},
    );
  }
}
