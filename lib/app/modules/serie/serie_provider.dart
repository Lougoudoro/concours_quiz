import 'package:cncours_quiz/app/core/client/my_client.dart';
import 'package:get/get.dart';

class SerieProvider {
  final MyClient _client = Get.find<MyClient>();
  String resource = 'series';

  Future<dynamic> questions({required int serieId}) async {
    return await _client.clientGet(
      apiRoute: "/$resource/$serieId/questions",
    );
  }
}
